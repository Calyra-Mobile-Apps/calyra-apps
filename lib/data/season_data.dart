// Lokasi file: lib/data/season_data.dart

import 'package:flutter/material.dart';

class SeasonDetail {
  final String description;
  final List<Color> colors;

  const SeasonDetail({required this.description, required this.colors});
}

final Map<String, SeasonDetail> seasonDetails = {
  'Warm Spring': const SeasonDetail(
    description: 'As a Warm Spring, your natural charm shines through bright, warm, and lively colors.',
    colors: [
      Color(0xfff7a325), Color(0xffa1d569), Color(0xfffff799), Color(0xffff8a80),
      Color(0xffa08269), Color(0xfff0a1a1), Color(0xfffdba5b), Color(0xffd52c3c),
      Color(0xff88c5cc), Color(0xffa481b6), Color(0xff604c8d), Color(0xffb89b80),
    ],
  ),
  'Cool Summer': const SeasonDetail(
    description: 'As a Cool Summer, your features are best enhanced by soft, cool, and muted colors.',
    colors: [
      Color(0xfff1c3d1), Color(0xffc1dbe6), Color(0xffa2a9d7), Color(0xffd780a1),
      Color(0xffa288a4), Color(0xff5a79a5), Color(0xff826b85), Color(0xffc9c9c9),
      Color(0xff673e6e), Color(0xff855768), Color(0xff2f4b68), Color(0xffb2d2d2),
    ],
  ),
  'Warm Autumn': const SeasonDetail(
    description: 'As a Warm Autumn, your natural radiance comes alive in rich, warm, and earthy colors.',
    colors: [
      Color(0xff4a633a), Color(0xffd58c58), Color(0xffb76a71), Color(0xff9f3b34),
      Color(0xff3f7175), Color(0xff5a9a9f), Color(0xff685f81), Color(0xff5f5434),
      Color(0xffe1d9c3), Color(0xffe3d091), Color(0xff4a3a3a), Color(0xff2d405d),
    ],
  ),
  'Cool Winter': const SeasonDetail(
    description: 'As a Cool Winter, your look is defined by sharp, cool, and vivid colors that complement your strong features.',
    colors: [
      Color(0xffffffff), Color(0xff000000), Color(0xffe3001a), Color(0xff0094d7),
      Color(0xfffdde00), Color(0xffb42051), Color(0xff94c03d), Color(0xff0058a3),
      Color(0xff7d287d), Color(0xffcccccc), Color(0xff0e3560), Color(0xffce0058),
    ],
  ),
};