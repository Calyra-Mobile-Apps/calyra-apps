// lib/screens/home/category_detail_screen.dart

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
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProductsBySeason();
  }

  Future<List<Product>> _fetchProductsBySeason() async {
    final firestoreService = FirestoreService();
    // Menggunakan category.title (misal: "Spring") untuk query
    final response = await firestoreService.getProductsBySeason(widget.category.title);

    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to load products')),
      );
      return [];
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
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No recommended products found.'));
            }
            
            // Menggunakan ProductGrid yang sudah ada
            return ProductGrid(products: snapshot.data!);
          },
        ),
      ),
    );
  }
}