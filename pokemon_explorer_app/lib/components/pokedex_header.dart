import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/components/pokemon_hint_bubble.dart';

class PokedexHeader extends StatelessWidget {
  final double height;
  final String? imageUrl; // optional image for the big circle

  const PokedexHeader({super.key, this.height = 80, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF992727), //
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                //big circle
                Positioned(
                  left: 10,
                  bottom: height * 0.1,
                  child: Container(
                    width: height * 0.85,
                    height: height * 0.85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                      color: imageUrl == null
                          ? const Color(0xFF8CF2F5)
                          : Colors.transparent,
                      image: imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null, // Default color if no image as input
                    ),
                    child: Stack(
                      children: [
                        if (imageUrl == null) _buildWhiteCircle(height),
                      ],
                    ),
                  ),
                ),
            
                // Ssmall green circle
                Positioned(
                  left: height * 0.85 + 15,
                  bottom: height * 0.2,
                  child: Container(
                    width: height * 0.2,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 3),
                      color: const Color(0xFF00CF01),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PokemonHintBubble(
              hints: [
                "Welcome to the world of Pokémon!",
                "Cool Stuff await you",
                "Plizzz Hire meeeeee...",
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Creates a white reflectin circle in the upper left part of the big circle
  Widget _buildWhiteCircle(double parentSize) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(parentSize * 0.1),
        child: Container(
          width: parentSize * 0.25,
          height: parentSize * 0.25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
