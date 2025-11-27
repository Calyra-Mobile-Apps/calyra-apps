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
    required this.skintoneGroupIds,
    required this.skintoneName,
    required this.imageSwatchUrl,
    this.linkProduct,
    this.description = '', 
    this.price = 0.0,
    this.purchaseUrl = '',
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
  
  final List<int> skintoneGroupIds; 
  
  final String skintoneName;
  final String imageSwatchUrl;
  final String? linkProduct;
  final String description; 
  final double price; 
  final String purchaseUrl;

  String get name => productName;
  String get imageUrl => imageSwatchUrl;

  factory Product.fromFirestore(Map<String, dynamic> data) {
    
    // --- LOGIKA PARSING SKINTONE (DIPERBAIKI) ---
    var rawSkintone = data['skintone_group_id'];
    List<int> parsedIds = [];

    if (rawSkintone is List) {
      // Jika data di Firebase bentuknya Array: [1, 2, 3]
      parsedIds = rawSkintone.map((e) => int.tryParse(e.toString()) ?? 0).toList();
    } else if (rawSkintone is int) {
      // Jika data di Firebase cuma angka: 1
      parsedIds.add(rawSkintone);
    } else if (rawSkintone is String) {
      // Jika data di Firebase string: "1, 2, 3" atau "1"
      // Kita pecah berdasarkan koma
      if (rawSkintone.contains(',')) {
        parsedIds = rawSkintone.split(',')
            .map((e) => int.tryParse(e.trim()) ?? 0) // Trim spasi & parse
            .where((e) => e != 0) // Hapus yang gagal parse
            .toList();
      } else {
        // String tunggal "1"
        int? val = int.tryParse(rawSkintone);
        if (val != null) parsedIds.add(val);
      }
    }
    // ------------------------------------------

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
      
      skintoneGroupIds: parsedIds, // Masukkan hasil parsing
          
      skintoneName: data['skintone_name'] ?? '',
      imageSwatchUrl: data['image_swatch_url'] ?? '',
      linkProduct: data['link_product'] as String?,
      description: data['description'] ?? '',
      price: (data['price'] is String)
          ? double.tryParse(data['price']) ?? 0.0
          : (data['price'] as num?)?.toDouble() ?? 0.0,
      purchaseUrl: data['link_product'] ?? '',
    );
  }
}
