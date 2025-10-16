// Lokasi file: lib/models/season_category.dart

import 'package:flutter/material.dart';

class SeasonCategory {
  final String title;
  final String subtitle;
  final String assetPath;
  final List<Color> gradientColors;
  // --- BARU: Menambahkan properti untuk deskripsi dan gambar palet ---
  final String description;
  final String paletteImagePath;
  // -----------------------------------------------------------------

  const SeasonCategory({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.gradientColors,
    // --- BARU: Menambahkan properti ke constructor ---
    required this.description,
    required this.paletteImagePath,
    // ------------------------------------------------
  });
}