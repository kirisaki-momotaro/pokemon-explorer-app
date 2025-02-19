import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/components/pokedex_header.dart';

class PokedexScreenTemplate extends StatelessWidget {
  final Widget screenContent; 
  final Color backgroundColor;
  final List<String> hints;
  const PokedexScreenTemplate({super.key, required this.screenContent,required this.backgroundColor, required this.hints});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: backgroundColor,     
      body: SafeArea(
        child: Column(
          children: [
            PokedexHeader(height: 100, hints: hints), 
            Expanded(child: screenContent), 
          ],
        ),
      ),
    );
  }
}
