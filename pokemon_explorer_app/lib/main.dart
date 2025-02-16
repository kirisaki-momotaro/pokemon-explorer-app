import 'package:flutter/material.dart';
import 'components/pokemon_type_grid.dart';
import 'components/animated_background.dart';
import 'components/speak_bubble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Type Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokemon Type Explorer"),
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Color(0xffc64444),
      body: Stack(
        children: [
          //PokeballBackground(backgroundColor: 'red',),

          Column(
            children: [
              Row(
                children: [
                  SizedBox(height: 20,width: 20,),
                  SpeakBubble(
                    bubbleText:
                        "Click on a type icon to learn more about my pals Pika!!",
                    highlightWords: ["type"],
                  ),
                ],
              ),
              PokemonTypeGrid(),
            ],
          )
        ],
      ),
    );
  }
}
