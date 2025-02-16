import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeakBubble extends StatelessWidget {
  final String bubbleText;
  final List<String> highlightWords;

  const SpeakBubble({super.key, required this.bubbleText, required this.highlightWords});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(33),
            border: Border.all(color: const Color(0xFFB9BB9B), width: 2),
          ),
          child: _buildHighlightedText(),
        ),
      ),
    );
  }

  Widget _buildHighlightedText() {
    List<TextSpan> spans = [];
    bubbleText.split(" ").forEach((word) {
      spans.add(
        TextSpan(
          text: "$word ", // Preserve spacing
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w600, // SemiBold
            fontSize: 16,
            color: highlightWords.contains(word) ? Colors.red : Colors.black, // Highlight multiple words
          ),
        ),
      );
    });

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}
