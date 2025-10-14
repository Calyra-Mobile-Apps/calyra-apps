import 'package:calyra/models/product.dart';

class BrandInfo {
  const BrandInfo({
    required this.name,
    required this.imageUrl,
    required this.logoPath,
    this.homeLogoPath,
    required this.products,
  });

  final String name;
  final String imageUrl;
  final String logoPath;
  final String? homeLogoPath;
  final List<Product> products;
}
