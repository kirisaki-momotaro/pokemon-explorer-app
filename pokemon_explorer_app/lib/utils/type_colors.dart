import 'package:flutter/material.dart';

class TypeColors {
  static const Map<String, Color> typeColors = {
    'fire': Color(0xFFE4613E),
    'fairy': Color(0xFFE18CE1),
    'ghost': Color(0xFF785279),
    'grass': Color(0xFF439837),
    'dark': Color(0xFF4F4747),
    'steel': Color(0xFF74B0CB),
    'water': Color(0xFF3099E1),
    'electric': Color(0xFFDFBC28),
    'dragon': Color(0xFF576FBC),
    'psychic': Color(0xFFE96C8C),
  };

  static Color getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? Colors.grey; // Default color if type not found
  }
}
