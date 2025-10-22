// Lokasi file: lib/screens/quiz/recommendations_screen.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/product.dart';
import 'package:calyra/screens/product/product_detail_screen.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:flutter/material.dart';

String _capitalize(String s) {
  if (s.isEmpty) return '';
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

class RecommendedProduct {
  final Product productInfo;
  final List<Product> recommendedShades;
  RecommendedProduct(
      {required this.productInfo, required this.recommendedShades});
}

class RecommendationsScreen extends StatefulWidget {
  final String brandName;
  final AnalysisResult analysisResult;
  const RecommendationsScreen(
      {super.key, required this.brandName, required this.analysisResult});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late Future<Map<String, List<RecommendedProduct>>> _categorizedProductsFuture;

  final List<String> complexionTypes = [
    'Foundation',
    'Concealer',
    'Cushion',
    'Powder',
    'Compact Powder',
    'Loose Powder',
    'BB Cream',
    'Tinted Moisturizer',
    'Bronzer',
    'Contour',
    'Liquid Complexion',
    'Powder Complexion'
  ];
  final List<String> colorTypes = [
    'Lipstick',
    'Liptint',
    'Lipcream',
    'Lip Gloss',
    'Blush',
    'Eyeshadow',
    'Lip Matte',
    'Liquid Lipstick'
  ];
  final List<String> _categoryOrder = [
    'Universal Products',
    'Liquid Complexion',
    'Powder Complexion',
    'Cheeks',
    'Lips',
    'Eyes'
  ];
  final Map<String, List<String>> _displayCategories = {
    'Universal Products': [],
    'Liquid Complexion': [
      'Foundation',
      'Concealer',
      'Cushion',
      'BB Cream',
      'Tinted Moisturizer',
      'Liquid Complexion'
    ],
    'Powder Complexion': [
      'Powder',
      'Compact Powder',
      'Loose Powder',
      'Powder Complexion'
    ],
    'Cheeks': ['Blush'],
    'Lips': [
      'Liptint',
      'Lipcream',
      'Lip Gloss',
      'Lipstick',
      'Lip Matte',
      'Liquid Lipstick'
    ],
    'Eyes': ['Eyeshadow'],
  };

  @override
  void initState() {
    super.initState();
    _categorizedProductsFuture = _fetchAndProcessRecommendations();
  }

  Future<Map<String, List<RecommendedProduct>>>
      _fetchAndProcessRecommendations() async {
    final firestoreService = FirestoreService();
    final response =
        await firestoreService.getProductsByBrandName(widget.brandName);
    if (response.isSuccess && response.data != null) {
      final allProducts = response.data!;
      final userUndertone = _capitalize(widget.analysisResult.undertone);
      final userSeason =
          _capitalize(widget.analysisResult.seasonResult.split(' ').last);
      final userSkintoneId = int.tryParse(widget.analysisResult.skintone) ?? 0;
      final isNeutralResult = userUndertone == 'Neutral';
      final List<Product> recommendedShades = [];
      final List<Product> universalShades = [];
      for (final product in allProducts) {
        final bool isUniversal =
            product.undertoneName.isEmpty && product.seasonName.isEmpty;
        if (isUniversal) {
          universalShades.add(product);
          continue;
        }
        if (!isNeutralResult) {
          bool isMatch = false;
          if (complexionTypes.contains(product.productType)) {
            final bool matchesUndertone =
                product.undertoneName == userUndertone;
            final bool matchesSkintone =
                product.skintoneGroupId == userSkintoneId;
            if (matchesSkintone || matchesUndertone) {
              isMatch = true;
            }
          } else if (colorTypes.contains(product.productType)) {
            if (product.undertoneName == userUndertone &&
                product.seasonName == userSeason) {
              isMatch = true;
            }
          }
          if (isMatch) {
            recommendedShades.add(product);
          }
        }
      }
      final allRecommendedShades = [...recommendedShades, ...universalShades];
      final Map<String, List<Product>> shadesByProductId = {};
      for (final shade in allRecommendedShades) {
        shadesByProductId.putIfAbsent(shade.productId, () => []).add(shade);
      }
      final List<RecommendedProduct> finalProducts =
          shadesByProductId.entries.map((entry) {
        return RecommendedProduct(
            productInfo: entry.value.first, recommendedShades: entry.value);
      }).toList();
      final Map<String, List<RecommendedProduct>> groupedForUI = {};
      for (final recProduct in finalProducts) {
        final type = recProduct.productInfo.productType;
        final isUniversal = recProduct.productInfo.undertoneName.isEmpty &&
            recProduct.productInfo.seasonName.isEmpty;
        if (isUniversal) {
          groupedForUI
              .putIfAbsent('Universal Products', () => [])
              .add(recProduct);
        }
        for (final category in _displayCategories.entries) {
          if (category.value.contains(type)) {
            groupedForUI.putIfAbsent(category.key, () => []).add(recProduct);
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
    final fullSeasonName =
        '${_capitalize(widget.analysisResult.undertone)} ${widget.analysisResult.seasonResult.split(' ').last}';
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.brandName} Spotlight',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'No specific recommendations found for your $fullSeasonName palette in this brand.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }
          final categorizedProducts = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.brandName} for Your\n$fullSeasonName Palette',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2),
                      ),
                      const SizedBox(height: 8),
                      const Text('Explore products picked just for you.',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
                ..._categoryOrder.map((categoryTitle) {
                  final productsInCategory = categorizedProducts[categoryTitle];
                  if (productsInCategory == null ||
                      productsInCategory.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CategoryPill(title: categoryTitle),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(20, 0, 5, 10),
                          itemCount: productsInCategory.length,
                          itemBuilder: (context, index) {
                            return _ProductItem(
                                recommendedProduct: productsInCategory[index]);
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

class _CategoryPill extends StatelessWidget {
  final String title;
  const _CategoryPill({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(1),
            bottomLeft: Radius.circular(1),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final RecommendedProduct recommendedProduct;
  const _ProductItem({required this.recommendedProduct});

  @override
  Widget build(BuildContext context) {
    final productInfo = recommendedProduct.productInfo;
    final shadeCount = recommendedProduct.recommendedShades.length;
    final allShadeNames =
        recommendedProduct.recommendedShades.map((s) => s.shadeName).join(', ');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productShades: recommendedProduct.recommendedShades,
            ),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Container(
                height: 140,
                width: 150,
                color: Colors.grey.shade100,
                child: Image.network(
                  productInfo.imageSwatchUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productInfo.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Shade: $allShadeNames',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$shadeCount Recommended Shade${shadeCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
