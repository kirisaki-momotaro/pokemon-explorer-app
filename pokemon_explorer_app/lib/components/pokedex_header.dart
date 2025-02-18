import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/components/pokemon_hint_bubble.dart';
import 'package:pokemon_explorer_app/components/pokedex_header_button.dart';
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
                  child: PokedexHeaderButton(size: height)
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

 
}
