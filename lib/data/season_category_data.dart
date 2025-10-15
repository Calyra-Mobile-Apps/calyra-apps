// lib/data/season_category_data.dart

import 'package:calyra/models/season_category.dart';
import 'package:flutter/material.dart';

final List<SeasonCategory> seasonCategories = [
  const SeasonCategory( // <-- TAMBAHKAN CONST DI SINI
    title: 'Spring',
    subtitle: 'Warm & Bright',
    assetPath: 'assets/images/icon-spring.png',
    gradientColors: [
      Color(0xFFFFD1DC),
      Color(0xFFFFF0F5),
    ],
  ),
  const SeasonCategory( // <-- TAMBAHKAN CONST DI SINI
    title: 'Summer',
    subtitle: 'Cool & Bright',
    assetPath: 'assets/images/icon-summer.png',
    gradientColors: [
      Color(0xFFB0E0E6),
      Color(0xFFE0FFFF),
    ],
  ),
  const SeasonCategory( // <-- TAMBAHKAN CONST DI SINI
    title: 'Autumn',
    subtitle: 'Warm & Muted',
    assetPath: 'assets/images/icon-autumn.png',
    gradientColors: [
      Color(0xFFF5DEB3),
      Color(0xFFFFF8E1),
    ],
  ),
  const SeasonCategory( // <-- TAMBAHKAN CONST DI SINI
    title: 'Winter',
    subtitle: 'Cool & Muted',
    assetPath: 'assets/images/icon-winter.png',
    gradientColors: [
      Color(0xFFE6E6FA),
      Color(0xFFFFFFFF),
    ],
  ),
];