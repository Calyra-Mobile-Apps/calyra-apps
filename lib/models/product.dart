class Product {
  const Product({
    required this.name,
    required this.imageUrl,
    this.description,
    this.price,
  });

  final String name;
  final String imageUrl;
  final String? description;
  final double? price;
}
