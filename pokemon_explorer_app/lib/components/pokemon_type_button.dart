import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_explorer_app/screens/pokemon_select_screen.dart';

class PokemonTypeButton extends StatelessWidget {
  final String type;

  const PokemonTypeButton({super.key, required this.type});

  static const Map<String, Color> typeColors = {
    'Fire': Color(0xFFE4613E),
    'Fairy': Color(0xFFE18CE1),
    'Ghost': Color(0xFF785279),
    'Grass': Color(0xFF439837),
    'Dark': Color(0xFF4F4747),
    'Steel': Color(0xFF74B0CB),
    'Water': Color(0xFF3099E1),
    'Electric': Color(0xFFDFBC28),
    'Dragon': Color(0xFF576FBC),
    'Psychic': Color(0xFFE96C8C),
  };

  @override
  Widget build(BuildContext context) {
    final Color typeColor = typeColors[type] ?? Colors.grey;
    final String imagePath = 'assets/poke_type_icons/${type.toLowerCase()}.png';

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration:
                  const Duration(milliseconds: 400), // ✅ Smooth animation
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PokemonSelectScreen(pokemonType: type),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0), // ✅ Start from the right
                    end: Offset.zero, // ✅ Move to normal position
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadowColor: Colors.black54,
            elevation: 5,
            side: BorderSide(
              color: Color(0xFFB9B9B9),
              width: 2,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Text(
                type,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
