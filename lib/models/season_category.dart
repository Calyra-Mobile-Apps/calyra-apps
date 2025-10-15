// lib/models/season_category.dart

import 'package:flutter/material.dart';

class SeasonCategory {
  final String title;
  final String subtitle;
  final String assetPath;
  final List<Color> gradientColors;

  const SeasonCategory({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.gradientColors,
  });
}