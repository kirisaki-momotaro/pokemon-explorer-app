import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokemon_explorer_app/components/animated_background.dart';
import 'package:pokemon_explorer_app/components/pokeball_loading_indicator.dart';
import 'package:pokemon_explorer_app/components/pokedex_screen_template.dart';
import 'package:pokemon_explorer_app/components/pokemon_entry.dart';
import 'package:pokemon_explorer_app/components/speak_bubble.dart';
import 'package:pokemon_explorer_app/screens/pokemon_display_screen.dart';
import 'package:pokemon_explorer_app/classes/pokemon.dart';
import 'package:pokemon_explorer_app/components/pokemon_search_bar.dart';

class PokemonSelectScreen extends StatefulWidget {
  final String pokemonType;

  const PokemonSelectScreen({super.key, required this.pokemonType});

  @override
  State<PokemonSelectScreen> createState() => _PokemonSelectScreenState();
}

class _PokemonSelectScreenState extends State<PokemonSelectScreen> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();
  final List<Pokemon> _pokemonList = [];
  int _currentIndex = 0;
  int _offset = 0;
  bool _isLoading = false;
  final int _limit = 10; // Load 10 Pokémon at a time

  @override
  void initState() {
    super.initState();
    _fetchPokemon();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_isLoading &&
        _scrollController.selectedItem == _pokemonList.length - 1) {
      _fetchPokemon();
    }
  }

  Future<void> _fetchPokemon() async {
    setState(() {
      _isLoading = true;
    });

    final url =
        "https://pokeapi.co/api/v2/type/${widget.pokemonType.toLowerCase()}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> pokemonEntries = data['pokemon'];

        final List<Pokemon> newPokemon = [];

        for (var entry in pokemonEntries.skip(_offset).take(_limit)) {
          int id = int.parse(
              entry['pokemon']['url'].split('/').reversed.elementAt(1));

          // fech description
          String description = await _fetchPokemonDescription(id);

          newPokemon.add(Pokemon(
            id: id,
            name: entry['pokemon']['name'],
            spriteUrl:
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
            types: [widget.pokemonType],
            description: description,
            hp: (50 + id % 50).toInt(),
            attack: (50 + id % 50).toInt(),
            defense: (50 + id % 50).toInt(),
          ));
        }

        setState(() {
          _pokemonList.addAll(newPokemon);
          _offset += _limit;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching Pokémon: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _fetchPokemonDescription(int pokemonId) async {
    final url = "https://pokeapi.co/api/v2/pokemon-species/$pokemonId/";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract the first english flavor text entry
        for (var entry in data['flavor_text_entries']) {
          if (entry['language']['name'] == 'en') {
            return entry['flavor_text']
                .replaceAll("\n", " ")
                .replaceAll("\f", " ");
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching Pokémon description: $e");
    }

    return "Team Rocket Stole this Pokemon's Data, Our Ranger Team Currently Working on it.";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent keyboard from causing overflow
      body: SafeArea(
        child: PokedexScreenTemplate(
          backgroundColor: Colors.black,
          screenContent: Stack(
            children: [
              PokeballBackground(backgroundColor: 'black'),

              Column(
                children: [
                  const SizedBox(height: 100), // Ensures space above content

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 350,
                            child: _pokemonList.isEmpty
                                ? const Center(
                                    child: PokeballLoadingIndicator(size: 200),
                                  )
                                : ListWheelScrollView.useDelegate(
                                    controller: _scrollController,
                                    physics: _isLoading
                                        ? const NeverScrollableScrollPhysics()
                                        : const FixedExtentScrollPhysics(),
                                    itemExtent: 60,
                                    perspective: 0.002,
                                    diameterRatio: 2.5,
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        _currentIndex = index;
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      childCount: _pokemonList.length +
                                          (_isLoading ? 1 : 0),
                                      builder: (context, index) {
                                        if (index >= _pokemonList.length) {
                                          return const Center(
                                              child: PokeballLoadingIndicator(
                                                  size: 50));
                                        }

                                        double distanceFromCenter =
                                            (_currentIndex - index)
                                                .abs()
                                                .toDouble();
                                        double opacity =
                                            (1.0 - (distanceFromCenter * 0.3))
                                                .clamp(0.4, 1.0);
                                        double scale =
                                            (1.2 - distanceFromCenter * 0.2)
                                                .clamp(0.9, 1.2);

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Opacity(
                                            opacity: opacity,
                                            child: Transform.scale(
                                              scale: scale,
                                              child: SizedBox(
                                                width: screenWidth * 0.8,
                                                child: PokemonEntry(
                                                  spriteUrl: _pokemonList[index]
                                                      .spriteUrl,
                                                  pokemonName:
                                                      _pokemonList[index].name,
                                                  pokemonIndex:
                                                      _pokemonList[index].id,
                                                  pokemonType:
                                                      widget.pokemonType,
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        transitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    400),
                                                        pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) =>
                                                            PokemonDisplayScreen(
                                                                pokemon:
                                                                    _pokemonList[
                                                                        index]),
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          return SlideTransition(
                                                            position:
                                                                Tween<Offset>(
                                                              begin:
                                                                  const Offset(
                                                                      1, 0),
                                                              end: Offset.zero,
                                                            ).animate(
                                                                    animation),
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 20),

                          // SpeakBubble - Prevent Cutting
                          if (_pokemonList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 30), // Ensures bottom space
                              child: Container(
                                constraints: const BoxConstraints(
                                    minHeight: 80), // Ensures visibility
                                child: SpeakBubble(
                                  bubbleText:
                                      _pokemonList[_currentIndex].description,
                                  highlightWords: [],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Search Bar at the Top
              Positioned(
                top: 20,
                left: 16,
                right: 16,
                child: PokemonSearchBar(
                  type: widget.pokemonType,
                  onSelectPokemon: (selectedPokemon) {
                    debugPrint("Selected Pokémon: ${selectedPokemon.name}");
                  },
                ),
              ),
            ],
          ),
          hints: [
            'Tap on a Pokémon to Learn More',
            'Tap on the Search Bar to Search',
            'I\'m super sleepy',
            'Miss being a Kid...',
            'Pokémon are Soooooo Cool!!'
          ],
        ),
      ),
    );
  }
}
