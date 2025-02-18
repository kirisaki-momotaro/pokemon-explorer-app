import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/components/pokedex_screen_template.dart';

class PokemonSelectScreen extends StatelessWidget {
  const PokemonSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PokedexScreenTemplate(
      backgroundColor: Colors.white, 
      screenContent: Center(
        child: Text(
          "Choose your Pokémon!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
