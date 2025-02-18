import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokemon_explorer_app/utils/type_colors.dart';
import 'package:pokemon_explorer_app/classes/pokemon.dart';
import 'package:pokemon_explorer_app/screens/pokemon_display_screen.dart';

class PokemonSearchBar extends StatefulWidget {
  final String type;
  final Function(Pokemon)? onSelectPokemon;

  const PokemonSearchBar({
    super.key,
    required this.type,
    this.onSelectPokemon,
  });

  @override
  _PokemonSearchBarState createState() => _PokemonSearchBarState();
}

class _PokemonSearchBarState extends State<PokemonSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  //Stores names & IDs of pokemon of the specific type
  List<Map<String, dynamic>> _allPokemonNamesAndIds = [];
  List<Map<String, dynamic>> _filteredPokemon = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _removeOverlay();
    });

    // Fetch pokemon of this type
    _fetchAllPokemonNamesOfType();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  //Fetch all pokemon names & IDs belonging to the selected type
  Future<void> _fetchAllPokemonNamesOfType() async {
    setState(() => _isFetching = true);

    final url = "https://pokeapi.co/api/v2/type/${widget.type.toLowerCase()}";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pokemonList = data['pokemon'] as List<dynamic>;

        final extractedData = pokemonList.map((entry) {
          final pokemonData = entry['pokemon'];
          final urlParts = pokemonData['url'].split('/');
          final id = int.tryParse(urlParts[urlParts.length - 2]) ?? 0;

          return {
            'name': pokemonData['name'],
            'id': id,
          };
        }).toList();

        setState(() {
          _allPokemonNamesAndIds = extractedData;
        });
      }
    } catch (e) {
      debugPrint("Error fetching Pokémon of type ${widget.type}: $e");
    } finally {
      setState(() => _isFetching = false);
    }
  }

  //filter pokemon based on search input
  void _onSearch(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }

    if (_allPokemonNamesAndIds.isEmpty && !_isFetching) {
      await _fetchAllPokemonNamesOfType();
    }

    //Filter names or IDs
    final matches = _allPokemonNamesAndIds
        .where((pokemon) =>
            pokemon['name'].toLowerCase().contains(query.toLowerCase()) ||
            pokemon['id'].toString() == query)
        .toList();

    // Limit to 3 results
    final limitedResults = matches.take(3).toList();

    setState(() => _filteredPokemon = limitedResults);

    if (limitedResults.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  //When selecting a pokemn
  Future<void> _selectPokemon(Map<String, dynamic> pokemonData) async {
    final name = pokemonData['name'];
    _controller.text = name;
    _removeOverlay();
    _focusNode.unfocus();

    final pokemon = await _fetchPokemonData(name);
    if (pokemon == null) return;

    // If an external callback is provided, use it
    widget.onSelectPokemon?.call(pokemon);

    // Navigate to pokemon display screen
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            PokemonDisplayScreen(pokemon: pokemon),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  //Fetch full pokemon details (stats, sprite, description)
  Future<Pokemon?> _fetchPokemonData(String name) async {
    final url = "https://pokeapi.co/api/v2/pokemon/$name";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final speciesUrl = data['species']['url'];
        final speciesResponse = await http.get(Uri.parse(speciesUrl));

        String description = "No description available.";
        if (speciesResponse.statusCode == 200) {
          final speciesData = json.decode(speciesResponse.body);
          for (var entry in speciesData['flavor_text_entries']) {
            if (entry['language']['name'] == 'en') {
              description = entry['flavor_text']
                  .replaceAll('\n', ' ')
                  .replaceAll('\f', ' ');
              break;
            }
          }
        }

        return Pokemon(
          id: data['id'],
          name: data['name'],
          spriteUrl: data['sprites']['front_default'],
          types: List<String>.from(data['types'].map((t) => t['type']['name'])),
          description: description,
          hp: data['stats'][0]['base_stat'],
          attack: data['stats'][1]['base_stat'],
          defense: data['stats'][2]['base_stat'],
        );
      }
    } catch (e) {
      debugPrint("Error fetching Pokémon details: $e");
    }
    return null;
  }

  //Show dropdown overlay
  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _focusNode.unfocus();
                _removeOverlay();
              },
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width - 32,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 50),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _filteredPokemon.length,
                  itemBuilder: (context, index) {
                    final pokemon = _filteredPokemon[index];
                    return ListTile(
                      title: Text("${pokemon['name']} #${pokemon['id']}"),
                      onTap: () => _selectPokemon(pokemon),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = TypeColors.getTypeColor(widget.type);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onSearch,
            decoration: InputDecoration(
              filled: true,
              fillColor: typeColor,
              hintText: "Search Pokémon (name or ID)...",
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
