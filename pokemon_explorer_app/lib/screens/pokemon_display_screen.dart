import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/classes/pokemon.dart';
import 'package:pokemon_explorer_app/components/pokedex_screen_template.dart';
import 'package:pokemon_explorer_app/components/pokemon_type_label.dart';
import 'package:pokemon_explorer_app/components/speak_bubble.dart';
import 'package:pokemon_explorer_app/components/pokemon_stat_display_board.dart';

class PokemonDisplayScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDisplayScreen({super.key, required this.pokemon});
  static const Map<String, Color> typeColors = {
    'Fire': Color(0xFFE4613E),
    'Fairy': Color(0xFFE18CE1),
    'Ghost': Color(0xFF785279),
    'Grass': Color(0xFF439837),
    'Dark': Color(0xFF4F4747),
    'Steel': Color(0xFF74B0CB),
    'Water': Color(0xFF3099E1),
    'Electric': Color(0xFFDFBC28),
    'Dragon': Color(0xFF576FBC),
    'Psychic': Color(0xFFE96C8C),
  };
  @override
  Widget build(BuildContext context) {
    return PokedexScreenTemplate(
      backgroundColor: Colors.white,
      screenContent: Column(
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
                color: typeColors[pokemon.types[0]],
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
      ),
    );
  }
}
