import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/utils/type_colors.dart';
class PokemonTypeLabel extends StatelessWidget {
  final String type;

  const PokemonTypeLabel({super.key, required this.type});



  @override
  Widget build(BuildContext context) {
    final Color typeColor = TypeColors.getTypeColor(type);

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
