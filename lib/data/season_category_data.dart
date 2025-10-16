// Lokasi file: lib/data/season_category_data.dart

import 'package:calyra/models/season_category.dart';
import 'package:flutter/material.dart';

// --- DATA DIPERBARUI DENGAN DESKRIPSI DAN PALETTEIMAGEPATH ---
final List<SeasonCategory> seasonCategories = [
  const SeasonCategory(
    title: 'Spring',
    subtitle: 'Warm & Bright',
    assetPath: 'assets/images/icon-spring.png',
    gradientColors: [Color(0xFFFFD1DC), Color(0xFFFFF0F5)],
    description: 'As a Spring, your natural radiance is complemented by bright, warm, and clear colors that enhance your fresh and lively appearance.',
    paletteImagePath: 'assets/images/gradasi-spring.png',
  ),
  const SeasonCategory(
    title: 'Summer',
    subtitle: 'Cool & Bright',
    assetPath: 'assets/images/icon-summer.png',
    gradientColors: [Color(0xFFB0E0E6), Color(0xFFE0FFFF)],
    description: 'As a Summer, your features are best enhanced by soft, cool, and muted colors that mirror the gentle and serene days of summer.',
    paletteImagePath: 'assets/images/gradasi-summer.png',
  ),
  const SeasonCategory(
    title: 'Autumn',
    subtitle: 'Warm & Muted',
    assetPath: 'assets/images/icon-autumn.png',
    gradientColors: [Color(0xFFF5DEB3), Color(0xFFFFF8E1)],
    description: 'As an Autumn, your natural warmth is complemented by soft, warm, and earthy colors that enhance your cozy and grounded appearance.',
    paletteImagePath: 'assets/images/gradasi-autumn.png',
  ),
  const SeasonCategory(
    title: 'Winter',
    subtitle: 'Cool & Muted',
    assetPath: 'assets/images/icon-winter.png',
    gradientColors: [Color(0xFFE6E6FA), Color(0xFFFFFFFF)],
    description: 'As a Winter, your look is defined by sharp, cool, and vivid colors that complement your naturally strong and contrasting features.',
    paletteImagePath: 'assets/images/gradasi-winter.png',
  ),
];
