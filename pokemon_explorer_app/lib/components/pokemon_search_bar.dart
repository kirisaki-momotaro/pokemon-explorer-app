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

  // All pokemon names of this type stored locally
  List<String> _allPokemonNames = [];


  List<String> _filteredNames = [];

  bool _isFetchingAllNames = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _removeOverlay();
    });
    // Fetch the list of all pokmon names once
    _fetchAllPokemonNames();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  // Fetch all pokemn names for partial matches
  Future<void> _fetchAllPokemonNames() async {
    setState(() => _isFetchingAllNames = true);

    const url = "https://pokeapi.co/api/v2/pokemon?limit=20000&offset=0";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>;

        // Extract all names
        final names = results.map((e) => e['name'] as String).toList();

        setState(() {
          _allPokemonNames = names; // e.g., [bulbasaur, ivysaur, ...] pokemon names
        });
      }
    } catch (e) {
      debugPrint("Error fetching all pokemon names: $e");
    } finally {
      setState(() => _isFetchingAllNames = false);
    }
  }

  /// On text change, check for matching pokemon
  void _onSearch(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      return;
    }

    // If not loaded yet, fetch them
    if (_allPokemonNames.isEmpty && !_isFetchingAllNames) {
      await _fetchAllPokemonNames();
    }

    // Filter names for partial match
    final matches = _allPokemonNames
        .where((name) => name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Limit to 3 pokemon as item
    final limited = matches.take(3).toList();

    setState(() => _filteredNames = limited);

    if (limited.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  
  Future<void> _selectName(String name) async {
    _controller.text = name;
    _removeOverlay();
    _focusNode.unfocus();

    // Fetch full Pokémon data
    final pokemon = await _fetchPokemonData(name);
    if (pokemon == null) return;

    // External callback if any
    widget.onSelectPokemon?.call(pokemon);

    // Or navigate to PokemonDisplayScreen
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

  // Fetch full Pokemon data (stats, sprite) , description
  Future<Pokemon?> _fetchPokemonData(String name) async {
    final url = "https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final speciesUrl = data['species']['url'] as String;
        final speciesResp = await http.get(Uri.parse(speciesUrl));
        String description = "No description available.";
        if (speciesResp.statusCode == 200) {
          final speciesData = json.decode(speciesResp.body);
          // Find first English flavor text
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
          types: List<String>.from(
            data['types'].map((t) => t['type']['name']),
          ),
          description: description,
          hp: data['stats'][0]['base_stat'],
          attack: data['stats'][1]['base_stat'],
          defense: data['stats'][2]['base_stat'],
        );
      }
    } catch (e) {
      debugPrint("Error fetching pokemon data: $e");
    }
    return null;
  }

  /// Show the dropdown overlay
  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tapping outside dismisses
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _focusNode.unfocus();
                _removeOverlay();
              },
            ),
          ),

          // The dropdown overlay
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
                  itemCount: _filteredNames.length,
                  itemBuilder: (context, index) {
                    final name = _filteredNames[index];
                    return ListTile(
                      title: Text(name),
                      onTap: () => _selectName(name),
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
              hintText: "Search Pokemon (partial name) or ID...",
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
