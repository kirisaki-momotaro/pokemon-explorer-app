import 'package:flutter/material.dart';
import 'dart:math' as math;

class PokeballLoadingIndicator extends StatefulWidget {
  final double size; 

  const PokeballLoadingIndicator({super.key, this.size = 100});

  @override
  State<PokeballLoadingIndicator> createState() => _PokeballLoadingIndicatorState();
}

class _PokeballLoadingIndicatorState extends State<PokeballLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Image.asset(
            'assets/pokeballs/pokeball-fire.png', 
            width: widget.size,
            height: widget.size,
          ),
        );
      },
    );
  }
}
