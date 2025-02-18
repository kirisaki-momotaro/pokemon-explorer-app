import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/screens/pokedex_main_screen.dart';
import 'package:pokemon_explorer_app/screens/pokemon_select_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokemon Explorer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PokedexMainScreen(),
      },
    );
  }
}
