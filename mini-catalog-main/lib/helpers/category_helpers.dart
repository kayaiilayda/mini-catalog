import 'package:flutter/material.dart';

/// Kategori bazlı yardımcı fonksiyonlar.
class CategoryHelpers {
  static IconData getIcon(String category) {
    switch (category) {
      case 'Elektronik':
        return Icons.devices_rounded;
      case 'Spor':
        return Icons.fitness_center_rounded;
      case 'Aksesuar':
        return Icons.watch_rounded;
      case 'Ev & Yaşam':
        return Icons.home_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  static Color getColor(String category) {
    switch (category) {
      case 'Elektronik':
        return const Color(0xFF1976D2);
      case 'Spor':
        return const Color(0xFF388E3C);
      case 'Aksesuar':
        return const Color(0xFFE64A19);
      case 'Ev & Yaşam':
        return const Color(0xFF7B1FA2);
      default:
        return const Color(0xFF616161);
    }
  }
}
