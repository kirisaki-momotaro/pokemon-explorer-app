import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_explorer_app/components/pokeball_loading_indicator.dart';
import 'package:pokemon_explorer_app/utils/type_colors.dart';

class PokemonEntry extends StatelessWidget {
  final String spriteUrl;
  final String pokemonName;
  final int pokemonIndex;
  final String pokemonType;
  final VoidCallback onPressed;

  const PokemonEntry({
    super.key,
    required this.spriteUrl,
    required this.pokemonName,
    required this.pokemonIndex,
    required this.pokemonType,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color typeColor = TypeColors.getTypeColor(pokemonType);
    const Color infoColor = Color(0xFF4E4E4E);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black54,
        elevation: 5,
      ),
      child: Container(
        height: 60, // Base height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 60,
                  child: CustomPaint(
                    painter: DiagonalSplitPainter(typeColor, infoColor),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      color: infoColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "$pokemonName #$pokemonIndex",
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Container(
                width: 60,
                padding: const EdgeInsets.all(8.0),
                child: Transform.scale(
                  scale: 2.4,
                  child: CachedNetworkImage(
                    imageUrl: spriteUrl,
                    placeholder: (context, url) =>
                        const PokeballLoadingIndicator(size: 60),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagonalSplitPainter extends CustomPainter {
  final Color leftColor;
  final Color rightColor;

  DiagonalSplitPainter(this.leftColor, this.rightColor);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintLeft = Paint()..color = leftColor;
    final Paint paintRight = Paint()..color = rightColor;
    final Path leftPath = Path();
    final Path rightPath = Path();

    // Left Triangle
    leftPath.moveTo(0, 0);
    leftPath.lineTo(size.width, 0);
    leftPath.lineTo(0, size.height);
    leftPath.close();

    // Right Triangle
    rightPath.moveTo(size.width, 0);
    rightPath.lineTo(size.width, size.height);
    rightPath.lineTo(0, size.height);
    rightPath.close();

    // Draw both sections
    canvas.drawPath(leftPath, paintLeft);
    canvas.drawPath(rightPath, paintRight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
