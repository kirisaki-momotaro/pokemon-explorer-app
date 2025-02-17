import 'package:flutter/material.dart';
import 'dart:async';

class PokemonHintBubble extends StatefulWidget {
  final List<String> hints;
  final Duration textSpeed;
  final String fontFamily;

  const PokemonHintBubble({
    super.key,
    required this.hints,
    this.textSpeed = const Duration(milliseconds: 50),
    this.fontFamily = "PokemonClassic", //pokemon red-blue font
  });

  @override
  _PokemonHintBubbleState createState() => _PokemonHintBubbleState();
}

class _PokemonHintBubbleState extends State<PokemonHintBubble> {
  int currentHintIndex = 0;
  String displayedText = "";
  int charIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTextAnimation();
  }

  void _startTextAnimation() {
    displayedText = "";
    charIndex = 0;
    _timer = Timer.periodic(widget.textSpeed, (timer) {
      if (charIndex < widget.hints[currentHintIndex].length) {
        setState(() {
          displayedText += widget.hints[currentHintIndex][charIndex];
          charIndex++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), _nextHint);
      }
    });
  }

  void _nextHint() {
    if (currentHintIndex < widget.hints.length - 1) {
      setState(() {
        currentHintIndex++;
        displayedText = "";
      });
    } else {
      setState(() {
        currentHintIndex = 0;
        displayedText = "";
      });
    }
    _startTextAnimation();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        displayedText,
        style: TextStyle(
          fontSize: 16,
          fontFamily: widget.fontFamily,
          color: Colors.white,
        ),
      ),
    );
  }
}
