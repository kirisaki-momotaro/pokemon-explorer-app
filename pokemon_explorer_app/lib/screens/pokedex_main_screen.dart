import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer_app/components/animated_background.dart';
import 'package:pokemon_explorer_app/components/pokedex_screen_template.dart';
import 'package:pokemon_explorer_app/components/pokemon_type_grid.dart';
import 'package:pokemon_explorer_app/components/speak_bubble.dart';
import 'package:pokemon_explorer_app/components/pokedex_header.dart';
import 'dart:math' as math;
import 'package:pokemon_explorer_app/components/pokeball_loading_indicator.dart';

class PokedexMainScreen extends StatefulWidget {
  const PokedexMainScreen({super.key});

  @override
  State<PokedexMainScreen> createState() => _PokedexMainScreenState();
}

class _PokedexMainScreenState extends State<PokedexMainScreen>
    with SingleTickerProviderStateMixin {
  String? spriteUrl;
  bool isLoading = true;
  final int maxPokemon = 898;
  late AnimationController _controller;
  List<String> types = [
    'Fire',
    'Fairy',
    'Ghost',
    'Grass',
    'Dark',
    'Steel',
    'Water',
    'Electric',
    'Dragon',
    'Psychic'
  ];

  @override
  void initState() {
    super.initState();
    fetchRandomPokemon();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchRandomPokemon() async {
    final randomId = math.Random().nextInt(maxPokemon) + 1;
    final url = 'https://pokeapi.co/api/v2/pokemon/$randomId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          spriteUrl = data['sprites']['front_default'];
          isLoading = false;
          _controller.stop();
        });
      }
    } catch (e) {
      debugPrint("Error fetching Pokémon: $e");
      setState(() {
        isLoading = false;
        _controller.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PokedexScreenTemplate(
      backgroundColor: const Color(0xffc64444),
      screenContent: Stack(
        children: [
          PokeballBackground(backgroundColor: 'red'),
          Column(
            children: [              
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: isLoading
                          ? PokeballLoadingIndicator()
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..scale(-1.5, 1.5),
                              child: CachedNetworkImage(
                                imageUrl: spriteUrl!,
                                placeholder: (context, url) => const SizedBox(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error,
                                        size: 50, color: Colors.red),
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: const SpeakBubble(
                      bubbleText:
                          "Click on a type icon to learn more about my pals!!",
                      highlightWords: ["type"],
                    ),
                  ),
                ],
              ),
              const PokemonTypeGrid(),
            ],
          ),
        ],
      ), hints: ['Welcome to Pokémon Explorer!', 'Choose a Pokémon Type to Search', 'hey, Dude.. Just Press a Button'],
    );
  }
}
