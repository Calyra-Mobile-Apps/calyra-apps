// Lokasi file: lib/screens/home/category_detail_screen.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/models/season_category.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:calyra/widgets/custom_product_image.dart';
import 'package:calyra/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:calyra/screens/product/product_detail_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key, required this.category});

  final SeasonCategory category;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late Future<Map<String, List<Product>>> _productsFuture;
  final FirestoreService _firestoreService = FirestoreService();

  // State untuk Filter yang dipilih (Default: All)
  String _selectedFilter = 'All';

  // --- 1. DEFINISI KATEGORI FILTER ---
  final List<String> _filterKeys = [
    'All',
    'Blush',
    'Highlighter',
    'Lip Gloss',
    'Lip Tint',
    'Lipstick',
    'Lip Care',
    'Eyes',
  ];

  // Mapping produk yang BOLEH tampil di halaman ini
  final Map<String, List<String>> _filterMapping = {
    'Blush': ['Blush'],
    'Highlighter': ['Highlighter'],
    'Lip Gloss': ['Lip Gloss', 'Lip Oil'],
    'Lip Tint': ['Liptint', 'Lip Stain'],
    'Lipstick': ['Lipstick', 'Lip Matte', 'Lipcream', 'Liquid Lipstick'],
    'Lip Care': ['Lip Balm'],
    'Eyes': ['Eyeshadow'],
  };

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _productsFuture = _fetchAndGroupProducts();
  }

  Future<Map<String, List<Product>>> _fetchAndGroupProducts() async {
    final response = await _firestoreService.getAllProducts();
    if (response.isSuccess && response.data != null) {
      final List<Product> allProducts = response.data!;
      final Map<String, List<Product>> groupedProducts = {};
      final String targetSeason = widget.category.title;
      for (var product in allProducts) {
        List<String> productSeasons =
            product.seasonName.split(',').map((e) => e.trim()).toList();
        if (productSeasons.contains(targetSeason)) {
          final key = product.productId;
          if (!groupedProducts.containsKey(key)) {
            groupedProducts[key] = [];
          }
          groupedProducts[key]!.add(product);
        }
      }
      return groupedProducts;
    } else {
      debugPrint('Error loading category products: ${response.message}');
      return {};
    }
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        widget.category.assetPath,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.category.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.category.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        widget.category.paletteImagePath,
                        height: 25,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(height: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filterKeys.length,
                itemBuilder: (context, index) {
                  final filterName = _filterKeys[index];
                  final isSelected = filterName == _selectedFilter;
                  return GestureDetector(
                    onTap: () => _onFilterSelected(filterName),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? null
                            : Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Text(
                          filterName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<Map<String, List<Product>>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return _buildEmptyState(
                        'No products found for ${widget.category.title}');
                  }
                  final allGroups = snapshot.data!.values.toList();
                  final allowedTypes =
                      _filterMapping.values.expand((e) => e).toList();
                  final filteredGroups = allGroups.where((group) {
                    final product = group.first;
                    if (!allowedTypes.contains(product.productType)) {
                      return false;
                    }
                    if (_selectedFilter == 'All') return true;
                    final currentFilterTypes = _filterMapping[_selectedFilter];
                    return currentFilterTypes != null &&
                        currentFilterTypes.contains(product.productType);
                  }).toList();
                  if (filteredGroups.isEmpty) {
                    return _buildEmptyState('No $_selectedFilter found.');
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 40),
                      physics: const BouncingScrollPhysics(),
                      itemCount: (filteredGroups.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        final int firstIndex = index * 2;
                        final int secondIndex = firstIndex + 1;
                        return Row(
                          children: [
                            Expanded(
                                child: _ProductItem(
                                    recommendedProduct: RecommendedProduct(
                                        productInfo:
                                            filteredGroups[firstIndex].first,
                                        recommendedShades:
                                            filteredGroups[firstIndex]))),
                            const SizedBox(width: 16),
                            Expanded(
                              child: secondIndex < filteredGroups.length
                                  ? _ProductItem(
                                      recommendedProduct: RecommendedProduct(
                                          productInfo:
                                              filteredGroups[secondIndex].first,
                                          recommendedShades:
                                              filteredGroups[secondIndex]))
                                  : const SizedBox(),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_alt_off, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class RecommendedProduct {
  final Product productInfo;
  final List<Product> recommendedShades;
  RecommendedProduct(
      {required this.productInfo, required this.recommendedShades});
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey.shade50,
                child: CustomProductImage(
                  imageUrl: productInfo.imageSwatchUrl,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productInfo.brandName,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    productInfo.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shadeCount > 1
                        ? '$shadeCount Shades'
                        : 'Shade: $allShadeNames',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
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
