import 'package:flutter/material.dart';

class PokemonSelectScreen extends StatelessWidget {
  const PokemonSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Pokémon"),
        backgroundColor: Colors.redAccent, 
      ),
      body: Center(
        child: Text(
          "Choose your Pokémon!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
