// lib/screens/quiz/recommendations_screen.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/product.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Tipe data baru untuk menampung produk yang sudah dikelompokkan
class RecommendedProduct {
  final Product productInfo;
  final List<Product> recommendedShades;

  RecommendedProduct({required this.productInfo, required this.recommendedShades});
}

// Helper untuk format teks
String _capitalize(String s) {
  if (s.isEmpty) return '';
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}


class RecommendationsScreen extends StatefulWidget {
  final String brandName;
  final AnalysisResult analysisResult;

  const RecommendationsScreen({
    super.key,
    required this.brandName,
    required this.analysisResult,
  });

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late final Future<Map<String, List<RecommendedProduct>>> _categorizedProductsFuture;

  // --- DAFTAR PRODUCT_TYPE DIPERBARUI BERDASARKAN LOG ANDA ---
  final List<String> complexionTypes = [
    'Foundation', 'Concealer', 'Cushion', 'Powder', 'Compact Powder', 'Loose Powder',
    'BB Cream', 'Tinted Moisturizer', 'Bronzer', 'Contour',
    'Liquid Complexion', 'Powder Complexion'
  ];
  final List<String> colorTypes = [
    'Lipstick', 'Liptint', 'Lipcream', 'Lip Gloss', 'Blush', 'Eyeshadow', 'Lip Matte',
    'Liquid Lipstick'
  ];

  final Map<String, List<String>> _displayCategories = {
    'Best Shade': ['Foundation', 'Concealer', 'Bronzer', 'Contour'],
    'Liquid Complexion': ['Foundation', 'Cushion', 'BB Cream', 'Tinted Moisturizer', 'Liquid Complexion'],
    'Powder Complexion': ['Powder', 'Compact Powder', 'Loose Powder', 'Powder Complexion'],
    'Cheeks': ['Blush'],
    'Lips': ['Liptint', 'Lipcream', 'Lip Gloss', 'Lipstick', 'Lip Matte', 'Liquid Lipstick'],
    'Eyes': ['Eyeshadow'],
  };

  @override
  void initState() {
    super.initState();
    _categorizedProductsFuture = _fetchAndProcessRecommendations();
  }

  Future<Map<String, List<RecommendedProduct>>> _fetchAndProcessRecommendations() async {
    final firestoreService = FirestoreService();
    
    final response = await firestoreService.getProductsByBrandName(widget.brandName);

    if (response.isSuccess && response.data != null) {
      final allProducts = response.data!;
      final allTypes = allProducts.map((p) => p.productType).toSet();
      print('ℹ️ Tipe produk yang ditemukan di database: $allTypes');

      final userUndertone = _capitalize(widget.analysisResult.undertone);
      final userSeason = _capitalize(widget.analysisResult.seasonResult);
      final userSkintoneId = int.tryParse(widget.analysisResult.skintone) ?? 0;
      
      final List<Product> recommendedShades = [];
      for (final product in allProducts) {
        bool isMatch = false;
        
        if (complexionTypes.contains(product.productType)) {
          if (product.undertoneName == userUndertone && product.skintoneGroupId == userSkintoneId) {
            isMatch = true;
          }
        } 
        else if (colorTypes.contains(product.productType)) {
          if (product.undertoneName == userUndertone && product.seasonName == userSeason) {
            isMatch = true;
          }
        }

        if (isMatch) {
          recommendedShades.add(product);
        }
      }
      
      print('✅ Ditemukan ${recommendedShades.length} SHADES yang cocok setelah difilter.');

      final Map<String, List<Product>> shadesByProductId = {};
      for (final shade in recommendedShades) {
        if (shadesByProductId.containsKey(shade.productId)) {
          shadesByProductId[shade.productId]!.add(shade);
        } else {
          shadesByProductId[shade.productId] = [shade];
        }
      }

      final List<RecommendedProduct> finalProducts = shadesByProductId.values.map((shades) {
        return RecommendedProduct(
          productInfo: shades.first,
          recommendedShades: shades,
        );
      }).toList();

      final Map<String, List<RecommendedProduct>> groupedForUI = {};
      for (final recProduct in finalProducts) {
        final type = recProduct.productInfo.productType;
        for (final category in _displayCategories.entries) {
          if (category.value.contains(type)) {
            if (groupedForUI.containsKey(category.key)) {
              groupedForUI[category.key]!.add(recProduct);
            } else {
              groupedForUI[category.key] = [recProduct];
            }
            break;
          }
        }
      }
      return groupedForUI;
    } else {
      throw Exception(response.message ?? 'Failed to load products.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... sisa kode tidak berubah
    final fullSeasonName = '${_capitalize(widget.analysisResult.undertone)} ${widget.analysisResult.seasonResult}';
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.brandName} Spotlight', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, List<RecommendedProduct>>>(
        future: _categorizedProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'No specific recommendations found for your $fullSeasonName palette in this brand.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ));
          }

          final categorizedProducts = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.brandName} for Your $fullSeasonName Palette',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Explore products picked just for you.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ..._displayCategories.entries.map((entry) {
                  final categoryTitle = entry.key;
                  final productsInCategory = categorizedProducts[categoryTitle];
                  if (productsInCategory == null || productsInCategory.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: _CategoryPill(title: categoryTitle),
                      ),
                      SizedBox(
                        height: (categoryTitle == 'Best Shade') ? 180 : 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: (categoryTitle == 'Best Shade') 
                              ? productsInCategory.fold<int>(0, (prev, e) => prev + e.recommendedShades.length)
                              : productsInCategory.length,
                          itemBuilder: (context, index) {
                            if (categoryTitle == 'Best Shade') {
                              final List<Product> allShades = productsInCategory.expand((p) => p.recommendedShades).toList();
                              return _ShadeItem(product: allShades[index]);
                            } else {
                              final recProduct = productsInCategory[index];
                              return _ProductItem(recommendedProduct: recProduct);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget-widget di bawah ini tidak perlu diubah
class _CategoryPill extends StatelessWidget {
  final String title;
  const _CategoryPill({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(30.0)),
        child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

class _ShadeItem extends StatelessWidget {
  final Product product;
  const _ShadeItem({required this.product});

  Color _hexToColor(String hexCode) {
    try {
      final String hex = hexCode.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch(e) {
      return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: SizedBox(
        width: 110,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 120,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(55), bottom: Radius.circular(15)),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: _hexToColor(product.colorHex),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3)
                    ),
                    child: Center(
                      child: Text(
                        product.shadeName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Shade for ${product.productType}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final RecommendedProduct recommendedProduct;
  const _ProductItem({required this.recommendedProduct});

  Future<void> _launchURL() async {
    final link = recommendedProduct.productInfo.linkProduct;
    if (link != null && link.isNotEmpty) {
      final Uri url = Uri.parse(link);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final productInfo = recommendedProduct.productInfo;
    final shadeNames = recommendedProduct.recommendedShades.map((s) => s.shadeName).join(', ');

    return GestureDetector(
      onTap: _launchURL,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: 110,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10.0)),
                child: Image.network(
                  productInfo.imageSwatchUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                productInfo.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  "Shade: $shadeNames",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}