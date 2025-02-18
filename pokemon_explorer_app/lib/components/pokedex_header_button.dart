import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

class PokedexHeaderButton extends StatelessWidget {
  final double size;
  const PokedexHeaderButton({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final bool showBackButton = currentRoute != '/';

    return GlowContainer(
      glowColor: const Color(0xFF8CF2F5), 
      blurRadius: 12, 
      shape: BoxShape.circle,
      child: Container(
        width: size * 0.85,
        height: size * 0.85,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 3),
          color: const Color(0xFF8CF2F5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showBackButton)
              SizedBox.expand(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(size * 0.5),
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: GlowIcon(
                        Icons.arrow_back,
                        size: size * 0.5,
                        color: Colors.white,
                        glowColor: Colors.red,
                        blurRadius: 9, 
                      ),
                    ),
                  ),
                ),
              ),
            _buildWhiteCircle(size),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteCircle(double parentSize) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(parentSize * 0.1),
        child: Container(
          width: parentSize * 0.25,
          height: parentSize * 0.25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
