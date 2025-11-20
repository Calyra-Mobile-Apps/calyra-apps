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
      Color(0xfff2cb7f),
      Color(0xffc3d97b),
      Color(0xfff4dfc7),
      Color(0xfff6ad51),
      Color(0xff8a9e34),
      Color(0xffeba488),
      Color(0xfff1784f),
      Color(0xffd23847),
      Color(0xff527ec1),
      Color(0xffc993cf),
      Color(0xff643e81),
      Color(0xffb29562),
    ],
  ),
  'Cool Summer': const SeasonDetail(
    description: 'As a Cool Summer, your features are best enhanced by soft, cool, and muted colors.',
    colors: [
      // Baris 1 (Atas)
      Color(0xff037754), // Hijau Tua
      Color(0xff76C6AD), // Hijau Mint
      Color(0xff2091BC), // Biru Laut
      Color(0xff6FC3DA), // Biru Langit Muda

      // Baris 2 (Tengah)
      Color(0xff635894), // Ungu Tua
      Color(0xffB0B4D9), // Ungu Muda/Lavender
      Color(0xffE6DB9F), // Kuning/Krem
      Color(0xffF6F7BF), // Kuning Sangat Muda

      // Baris 3 (Bawah)
      Color(0xffF06286), // Merah Muda Cerah
      Color(0xffF3C3D8), // Merah Muda Pucat
      Color(0xff7F636C), // Ungu Kecoklatan
      Color(0xffE1D4CB), // Krem/Beige
    ],
  ),
  'Warm Autumn': const SeasonDetail(
    description: 'As a Warm Autumn, your natural radiance comes alive in rich, warm, and earthy colors.',
    colors: [
      // Baris 1 (Atas)
      Color(0xff3E6536),
      Color(0xffCD956B),
      Color(0xffC06970),
      Color(0xffB13E37),

      // Baris 2 (Tengah)
      Color(0xff346D6B),
      Color(0xff599FB2),
      Color(0xff66577B),
      Color(0xff5E5536),

      // Baris 3 (Bawah)
      Color(0xffD9D3C1),
      Color(0xffD7C898),
      Color(0xff322122),
      Color(0xff323D5A),
    ],
  ),
  'Cool Winter': const SeasonDetail(
    description: 'As a Cool Winter, your look is defined by sharp, cool, and vivid colors that complement your strong features.',
    colors: [
      // Baris 1 (Atas)
      Color(0xff283562), // Biru Dongker
      Color(0xff20A5C7), // Biru Laut
      Color(0xff167E63), // Hijau Tua
      Color(0xff44C877), // Hijau Terang

      // Baris 2 (Tengah)
      Color(0xff4C3063), // Ungu Tua
      Color(0xffA764AF), // Ungu Anggrek
      Color(0xffF46998), // Pink Tua
      Color(0xffF5D9E5), // Pink Muda

      // Baris 3 (Bawah)
      Color(0xffFAF1A6), // Kuning Pucat
      Color(0xff000000), // Hitam
      Color(0xffA69F97), // Abu-abu Taupe
      Color(0xffD7D7CF), // Abu-abu Muda
    ],
  ),
};