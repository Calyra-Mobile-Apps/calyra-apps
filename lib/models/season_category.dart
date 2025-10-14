import 'package:calyra/models/product.dart';

class SeasonCategory {
  const SeasonCategory({
    required this.name,
    required this.description,
    required this.iconPath,
    required this.paletteImagePath,
    required this.products,
  });

  final String name;
  final String description;
  final String iconPath;
  final String paletteImagePath;
  final List<Product> products;
}
