import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE65100);
  static const Color secondary = Color(0xFF0F1E2E);
  static const Color background = Color(0xFFF6F8FA);

  static Color uvColor(double uv) {
    if (uv < 3) return const Color(0xFF2E7D32);
    if (uv < 6) return const Color(0xFFF9A825);
    if (uv < 8) return const Color(0xFFEF6C00);
    if (uv < 11) return const Color(0xFFC62828);
    return const Color(0xFF6A1B9A);
  }
}