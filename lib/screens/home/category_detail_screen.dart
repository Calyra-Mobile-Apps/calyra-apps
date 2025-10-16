// Lokasi file: lib/screens/home/category_detail_screen.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/models/season_category.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:calyra/widgets/product_grid.dart';
import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key, required this.category});

  final SeasonCategory category;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late Future<Map<String, List<Product>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchAndGroupProductsBySeason();
  }

  Future<Map<String, List<Product>>> _fetchAndGroupProductsBySeason() async {
    final firestoreService = FirestoreService();
    final response =
        await firestoreService.getProductsBySeason(widget.category.title);
    if (response.isSuccess && response.data != null) {
      final Map<String, List<Product>> groupedProducts = {};
      for (var product in response.data!) {
        final key = product.productId;

        if (!groupedProducts.containsKey(key)) {
          groupedProducts[key] = [];
        }
        groupedProducts[key]!.add(product);
      }

      return groupedProducts;
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Failed to load products')),
        );
      }
      return {};
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Row(
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
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        widget.category.assetPath,
                        width: 40,
                        height: 40,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.category.title,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.category.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(widget.category.paletteImagePath),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FutureBuilder<Map<String, List<Product>>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No recommended products found.'));
                    }
                    
                    final List<List<Product>> productGroups = snapshot.data!.values.toList();

                    return ProductGrid(productGroups: productGroups); 
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
