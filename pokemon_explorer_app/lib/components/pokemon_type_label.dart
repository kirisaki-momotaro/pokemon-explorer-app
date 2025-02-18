import 'package:flutter/material.dart';

class PokemonTypeLabel extends StatelessWidget {
  final String type;

  const PokemonTypeLabel({super.key, required this.type});

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
    final Color typeColor = typeColors[type] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: typeColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF898989), width: 2), // Stroke border
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.4), // Shadow color with transparency
            blurRadius: 6, // Soft blur effect
            offset: const Offset(3, 3), // Slight offset for depth
          ),
        ],
      ),
      child: Text(
        type,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
