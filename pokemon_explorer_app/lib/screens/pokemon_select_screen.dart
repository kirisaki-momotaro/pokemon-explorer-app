import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/components/animated_background.dart';
import 'package:pokemon_explorer_app/components/pokedex_screen_template.dart';
import 'package:pokemon_explorer_app/components/pokemon_entry.dart';

class PokemonSelectScreen extends StatelessWidget {
  const PokemonSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PokedexScreenTemplate(
      backgroundColor: Colors.white,
      screenContent: Stack(
        children: [
          PokeballBackground(backgroundColor: 'white'),
          Center(
            child: PokemonEntry(
              spriteUrl:
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
              pokemonName: "Pikachu",
              pokemonIndex: 25,
              pokemonType: "Electric",
            ),
          )
        ],
      ),
    );
  }
}
