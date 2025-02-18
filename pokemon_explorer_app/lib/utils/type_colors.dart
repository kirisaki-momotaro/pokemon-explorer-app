import 'package:flutter/material.dart';

class TypeColors {
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

  static Color getTypeColor(String type) {
    return typeColors[type] ?? Colors.grey; // Default color if type not found
  }
}
