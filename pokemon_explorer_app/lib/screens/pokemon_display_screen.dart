import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/classes/pokemon.dart';
import 'package:pokemon_explorer_app/components/pokedex_screen_template.dart';


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
    final Color typeColor = typeColors[pokemon.types.first] ?? Colors.grey;

    return PokedexScreenTemplate(
      backgroundColor: Colors.black,
      screenContent: Stack(
        children: [
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pokémon Image
              Image.network(
                pokemon.spriteUrl,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              // Pokémon Name & Index
              Text(
                "${pokemon.name} #${pokemon.id}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              // Pokémon Type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pokemon.types.first, // Display the first type
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
