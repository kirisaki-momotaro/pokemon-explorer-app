import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/components/animated_background.dart';
import 'package:pokemon_explorer_app/components/pokedex_screen_template.dart';
import 'package:pokemon_explorer_app/components/pokemon_entry.dart';
import 'package:pokemon_explorer_app/components/speak_bubble.dart';

class PokemonSelectScreen extends StatefulWidget {
  const PokemonSelectScreen({super.key});

  @override
  State<PokemonSelectScreen> createState() => _PokemonSelectScreenState();
}

class _PokemonSelectScreenState extends State<PokemonSelectScreen> {
  final FixedExtentScrollController _scrollController = FixedExtentScrollController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> _pokemonList = [
    {"sprite": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png", "name": "Bulbasaur", "index": 1, "type": "Grass", "info": "A Grass/Poison Pokémon."},
    {"sprite": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png", "name": "Charmander", "index": 4, "type": "Fire", "info": "A Fire-type Pokémon with a burning tail."},
    {"sprite": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png", "name": "Squirtle", "index": 7, "type": "Water", "info": "A Water-type Pokémon that evolves into Blastoise."},
    {"sprite": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png", "name": "Pikachu", "index": 25, "type": "Electric", "info": "Pikachu is an Electric-type Pokémon, famous as the mascot of Pokémon."},
    {"sprite": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/39.png", "name": "Jigglypuff", "index": 39, "type": "Fairy", "info": "A Fairy-type Pokémon known for its lullaby."},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; 

    return PokedexScreenTemplate(
      backgroundColor: Colors.black,
      screenContent: Stack(
        children: [
          PokeballBackground(backgroundColor: 'black'),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 350, // Adjust height to fit the screen
                child: ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  physics: const FixedExtentScrollPhysics(),
                  itemExtent: 60, 
                  perspective: 0.002, //3d depth effect
                  diameterRatio: 2.5, //curvature
                  onSelectedItemChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: _pokemonList.length,
                    builder: (context, index) {
                      double distanceFromCenter = (currentIndex - index).abs().toDouble();
                      double opacity = (1.0 - (distanceFromCenter * 0.3)).clamp(0.4, 1.0);
                      double scale = (1.2 - distanceFromCenter * 0.2).clamp(0.9, 1.2);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Opacity(
                          opacity: opacity,
                          child: Transform.scale(
                            scale: scale,
                            child: SizedBox(
                              width: screenWidth * 0.8, // Entry takes 80% of screen width
                              child: PokemonEntry(
                                spriteUrl: _pokemonList[index]["sprite"],
                                pokemonName: _pokemonList[index]["name"],
                                pokemonIndex: _pokemonList[index]["index"],
                                pokemonType: _pokemonList[index]["type"],
                                
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
              SpeakBubble(bubbleText: _pokemonList[currentIndex]["info"], highlightWords: [])
            ],
          ),
        ],
      ),
    );
  }
}
