import 'package:flutter/material.dart';
import 'pokemon_type_button.dart';
class PokemonTypeGrid extends StatelessWidget {
  const PokemonTypeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> types = [
      'Fire', 'Fairy', 'Ghost',
      'Grass', 'Dark', 'Steel',
      'Water', 'Electric', 'Dragon',
      'Psychic'
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PokemonTypeButton(type: types[0]),
              const SizedBox(width: 8),
              PokemonTypeButton(type: types[1]),
              const SizedBox(width: 8),
              PokemonTypeButton(type: types[2]),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PokemonTypeButton(type: types[3]),
              const SizedBox(width: 8),
              PokemonTypeButton(type: types[4]),
              const SizedBox(width: 8),
              PokemonTypeButton(type: types[5]),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PokemonTypeButton(type: types[6]),
              const SizedBox(width: 8),
              PokemonTypeButton(type: types[7]),
              const SizedBox(width: 8),
              PokemonTypeButton(type: types[8]),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _placeholderBox() ,
              const SizedBox(width: 8),
              PokemonTypeButton(type: types[9]),
              const SizedBox(width: 8),
              _placeholderBox() ,
              
            ],
          ),
        ],
      ),
    );
  }
}
Widget _placeholderBox() {
  return Expanded(
    child: SizedBox(
      width: double.infinity, // Matches the height of other buttons
    ),
  );
}