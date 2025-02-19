import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/classes/pokemon.dart';
import 'package:pokemon_explorer_app/components/pokedex_screen_template.dart';
import 'package:pokemon_explorer_app/components/pokemon_type_label.dart';
import 'package:pokemon_explorer_app/components/speak_bubble.dart';
import 'package:pokemon_explorer_app/components/pokemon_stat_display_board.dart';
import 'package:pokemon_explorer_app/components/animated_background.dart';
import 'package:pokemon_explorer_app/utils/type_colors.dart';

class PokemonDisplayScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDisplayScreen({super.key, required this.pokemon});
 
  @override
  Widget build(BuildContext context) {
    return PokedexScreenTemplate(
      backgroundColor: Colors.white,
      screenContent: Stack(
        children: [
          
          PokeballBackground(backgroundColor: 'white'),
          Column(
          children: [
            const SizedBox(height: 40),
        
            // Pokmon Image
            Image.network(
              pokemon.spriteUrl,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
        
            const SizedBox(height: 40),
        
            // Scrollable Info Section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB9BB9B), width: 2),
                  color: TypeColors.getTypeColor(pokemon.types[0]),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(                
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Pomon Name & Index
                      Text(
                        "${pokemon.name} #${pokemon.id}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
        
                      const SizedBox(height: 10),
        
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: pokemon.types
                            .map((type) => PokemonTypeLabel(type: type))
                            .toList(),
                      ),
        
                      const SizedBox(height: 20),
                      PokemonStatDisplayBoard(pokemon: pokemon),
                      const SizedBox(height: 20),
                      SpeakBubble(
                          bubbleText: pokemon.description, highlightWords: [])
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),]
      ), hints: ['Hope you are Having a Great Time', 'Nice Pokémon Huh?', 'Hope you are Not Going to Marry it or Sth.'],
    );
  }
}
