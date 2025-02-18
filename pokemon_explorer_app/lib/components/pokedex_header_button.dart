import 'package:flutter/material.dart';

class PokedexHeaderButton extends StatelessWidget {
  final double size; 
  const PokedexHeaderButton({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final bool showBackButton = currentRoute != '/'; 

    return Container(
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
          _buildWhiteCircle(size), 
          if (showBackButton) 
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
        ],
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
