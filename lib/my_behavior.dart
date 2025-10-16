// Lokasi file: lib/my_behavior.dart

import 'package:flutter/material.dart';

// Kelas ini digunakan untuk menghilangkan efek "glow" saat scrolling
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}