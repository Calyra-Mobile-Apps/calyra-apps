// Lokasi file: lib/screens/home/category_detail_screen.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/models/season_category.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:calyra/widgets/product_grid.dart'; // Pastikan widget ini ada
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to load products')),
      );
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title), // Menggunakan .title
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder<Map<String, List<Product>>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No recommended products found.'));
            }

            final List<List<Product>> productGroups =
                snapshot.data!.values.toList();

            return ProductGrid(productGroups: productGroups);
          },
        ),
      ),
    );
  }
}
