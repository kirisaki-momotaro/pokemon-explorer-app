import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

class PokeballBackground extends StatefulWidget {
  final String backgroundColor;

  const PokeballBackground({super.key, required this.backgroundColor});

  @override
  State<PokeballBackground> createState() => _PokeballBackgroundState();
}

class _PokeballBackgroundState extends State<PokeballBackground>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final bool isRed = widget.backgroundColor.toLowerCase() == 'red';
    final Color bgColor = isRed ? const Color(0xffc64444) : Colors.white;
    final String particleImage = isRed
        ? 'assets/pokeballs/pokeball_small_white.png'
        : 'assets/pokeballs/pokeball_small_red.png';

    return Scaffold(
      backgroundColor: bgColor,
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            spawnMaxRadius: 40,
            spawnMinRadius: 30,
            spawnMaxSpeed: 15,
            particleCount: 20,
            spawnMinSpeed: 0,
            spawnOpacity: 0.5,
            baseColor: Colors.black,
            image: Image.asset(particleImage),
          ),
        ),
        child: const Center(
          child: Text(
            '',
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
