import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/components/pokedex_header.dart';

class PokedexScreenTemplate extends StatelessWidget {
  final Widget screenContent; 
  final Color backgroundColor;
  const PokedexScreenTemplate({super.key, required this.screenContent,required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: backgroundColor,     
      body: Column(
        children: [
          const PokedexHeader(height: 100, imageUrl: null), 
          Expanded(child: screenContent), 
        ],
      ),
    );
  }
}
