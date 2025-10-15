// lib/models/brand_info.dart

import 'package:calyra/models/product.dart';

class BrandInfo {
  final String id; // <-- TAMBAHKAN ID
  final String name;
  final String imageUrl;
  final String logoPath;
  final String? homeLogoPath;
  final List<Product> products;

  const BrandInfo({
    required this.id, // <-- TAMBAHKAN ID DI CONSTRUCTOR
    required this.name,
    required this.imageUrl,
    required this.logoPath,
    this.homeLogoPath,
    this.products = const [], // Beri nilai default list kosong
  });
}