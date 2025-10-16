// Lokasi file: lib/models/product.dart

class Product {
  const Product({
    required this.brandName,
    required this.productType,
    required this.productName,
    required this.shadeId,
    required this.productId,
    required this.shadeName,
    required this.colorHex,
    required this.undertoneName,
    required this.seasonName,
    required this.skintoneGroupId,
    required this.skintoneName,
    required this.imageSwatchUrl,
    this.linkProduct,
  });

  final String brandName;
  final String productType;
  final String productName;
  final String shadeId;
  final String productId;
  final String shadeName;
  final String colorHex;
  final String undertoneName;
  final String seasonName;
  final dynamic skintoneGroupId;
  final String skintoneName;
  final String imageSwatchUrl;
  final String? linkProduct;

  String get name => productName;
  String get imageUrl => imageSwatchUrl;

  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      brandName: data['brand_name'] ?? '',
      productType: data['product_type'] ?? '',
      productName: data['product_name'] ?? '',
      shadeId: data['shade_id'] ?? '',
      productId: data['product_id'] ?? '',
      shadeName: data['shade_name'] ?? '',
      colorHex: data['color_hex'] ?? '',
      undertoneName: data['undertone_name'] ?? '',
      seasonName: data['season_name'] ?? '',
      skintoneGroupId: data['skintone_group_id'] ?? 0,
      skintoneName: data['skintone_name'] ?? '',
      imageSwatchUrl: data['image_swatch_url'] ?? '',
      linkProduct: data['link_product'] as String?,
    );
  }
}
