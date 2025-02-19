import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HPBar extends StatefulWidget {
  final int maxHP;

  const HPBar({super.key, required this.maxHP});

  @override
  _HPBarState createState() => _HPBarState();
}

class _HPBarState extends State<HPBar> with TickerProviderStateMixin {
  late AnimationController _hpTextController;
  late Animation<int> _hpTextAnimation;
  late AnimationController _hpBarController;
  late Animation<double> _hpBarAnimation;

  @override
  void initState() {
    super.initState();

    // hp animation for the text
    _hpTextController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _hpTextAnimation = IntTween(begin: 0, end: widget.maxHP).animate(
      CurvedAnimation(parent: _hpTextController, curve: Curves.easeOut),
    );

    // hp animation for the bar
    _hpBarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _hpBarAnimation =
        Tween<double>(begin: 0, end: widget.maxHP / widget.maxHP).animate(
      CurvedAnimation(parent: _hpBarController, curve: Curves.easeOut),
    );

    // init the animations
    _hpTextController.forward();
    _hpBarController.forward();
  }

  @override
  void dispose() {
    _hpTextController.dispose();
    _hpBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // text couting up
        AnimatedBuilder(
          animation: _hpTextAnimation,
          builder: (context, child) {
            return Text(
              "${_hpTextAnimation.value} / ${widget.maxHP}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
        ),

        Transform.translate(
          offset: const Offset(-7, -10),
          child: Row(
            children: [
              Stack(
                children: [
                  Text(
                    "HP",
                    style: GoogleFonts.passionOne(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -2,
                      color: const Color(0xFF66C478),
                    ),
                  ),
                  Text(
                    "HP",
                    style: GoogleFonts.passionOne(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -2,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 3),
              Expanded(
                child: AnimatedBuilder(
                  animation: _hpBarAnimation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Container(
                          height: 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.black, width: 1),
                            color: Colors.white, // Initially white
                            
                          ),
                        ),
                        // Filling Progress
                        FractionallySizedBox(
                          widthFactor: _hpBarAnimation.value,
                          child: Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.black, width: 2),
                              color: const Color(0xFF66C478),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
