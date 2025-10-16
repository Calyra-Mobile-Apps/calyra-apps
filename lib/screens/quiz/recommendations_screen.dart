// lib/screens/quiz/recommendations_screen.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationsScreen extends StatefulWidget {
  final String brandName;
  final String seasonName;

  const RecommendationsScreen({
    super.key,
    required this.brandName,
    required this.seasonName,
  });

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late Future<Map<String, List<Product>>> _groupedProductsFuture;

  // Mendefinisikan kategori dan tipe produk yang masuk di dalamnya
  final Map<String, List<String>> _categories = {
    'Best Shade': ['Foundation', 'Concealer', 'Bronzer', 'Contour'],
    'Liquid Complexion': ['Foundation', 'Cushion', 'Concealer'],
    'Powder Complexion': ['Powder', 'Compact Powder'],
  };

  @override
  void initState() {
    super.initState();
    _groupedProductsFuture = _fetchAndGroupProducts();
  }

  Future<Map<String, List<Product>>> _fetchAndGroupProducts() async {
    final firestoreService = FirestoreService();
    final response = await firestoreService.getProductsByBrandAndSeason(
        widget.brandName, widget.seasonName);

    if (response.isSuccess && response.data != null) {
      final Map<String, List<Product>> grouped = {};
      
      // Mengelompokkan produk berdasarkan productType
      for (final product in response.data!) {
        final type = product.productType;
        if (grouped.containsKey(type)) {
          grouped[type]!.add(product);
        } else {
          grouped[type] = [product];
        }
      }
      return grouped;
    } else {
      // Menampilkan pesan error jika gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message ?? 'Failed to load products.')),
        );
      }
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.brandName} Spotlight',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, List<Product>>>(
        future: _groupedProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recommendations found for this season.'));
          }

          final allProducts = snapshot.data!;

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
                        '${widget.brandName} for Your ${widget.seasonName} Palette',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Explore products picked just for you.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                ..._categories.entries.map((entry) {
                  final categoryTitle = entry.key;
                  final productTypes = entry.value;
                  final List<Product> categoryProducts = [];
                  for (var type in productTypes) {
                    if (allProducts.containsKey(type)) {
                      categoryProducts.addAll(allProducts[type]!);
                    }
                  }
                  
                  if (categoryProducts.isEmpty) {
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
                        height: categoryTitle == 'Best Shade' ? 180 : 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: categoryProducts.length,
                          itemBuilder: (context, index) {
                            final product = categoryProducts[index];
                            if (categoryTitle == 'Best Shade') {
                              return _ShadeItem(product: product);
                            } else {
                              return _ProductItem(product: product);
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

class _CategoryPill extends StatelessWidget {
  final String title;
  const _CategoryPill({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
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
      return Colors.grey.shade300; // Fallback color
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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(55),
                      bottom: Radius.circular(15)
                    ),
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
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Shade for ${product.productType}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  const _ProductItem({required this.product});

  Future<void> _launchURL() async {
    if (product.linkProduct != null && product.linkProduct!.isNotEmpty) {
      final Uri url = Uri.parse(product.linkProduct!);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
         // Could not launch the URL
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: SizedBox(
          width: 110,
          child: Column(
            children: [
              Container(
                height: 140,
                width: 110,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.network(
                  product.imageSwatchUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image));
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.productName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}