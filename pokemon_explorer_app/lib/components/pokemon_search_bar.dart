import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/utils/type_colors.dart';
import 'package:pokemon_explorer_app/classes/pokemon.dart';
import 'package:pokemon_explorer_app/screens/pokemon_display_screen.dart';
import 'package:pokemon_explorer_app/api_service.dart';
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
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  //Stores names & IDs of pokemon of the specific type
  List<Map<String, dynamic>> _allPokemonNamesAndIds = [];
  List<Map<String, dynamic>> _filteredPokemon = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
   

    // Fetch pokemon of this type
    _fetchAllPokemonNamesOfType();
  }

  @override
  void dispose() {
    _controller.dispose();
    
    _removeOverlay();
    super.dispose();
  }

  //Fetch all pokemon names & IDs belonging to the selected type
  Future<void> _fetchAllPokemonNamesOfType() async {
  setState(() => _isFetching = true);

  _allPokemonNamesAndIds = await ApiService.fetchAllPokemonNamesOfType(context, widget.type);

  setState(() => _isFetching = false);
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
  return await ApiService.fetchPokemonData(context, name);
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
