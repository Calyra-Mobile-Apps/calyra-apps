// Lokasi file: lib/screens/brand/brand_catalog_screen.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/models/season_filter.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:calyra/widgets/product_grid.dart';
import 'package:flutter/material.dart';

class BrandCatalogScreen extends StatefulWidget {
  const BrandCatalogScreen({
    super.key,
    required this.brandLogoPath,
    required this.brandName,
  });

  final String brandLogoPath;
  final String brandName;

  @override
  State<BrandCatalogScreen> createState() => _BrandCatalogScreenState();
}

class _BrandCatalogScreenState extends State<BrandCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<SeasonFilter> _seasonFilters = [
    SeasonFilter.all,
    ...SeasonFilter.values.where((e) => e != SeasonFilter.all).toList()
  ];
  SeasonFilter _selectedSeason = SeasonFilter.all;

  late Future<Map<String, List<Product>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<Map<String, List<Product>>> _fetchProducts() async {
    final firestoreService = FirestoreService();
    final response =
        await firestoreService.getProductsByBrandName(widget.brandName);

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  widget.brandLogoPath,
                  height: 72,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildSeasonFilter(),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<Map<String, List<Product>>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }

                    final allProductGroupsMap = snapshot.data!;
                    final List<List<Product>> filteredProductGroups = [];

                    final query = _searchController.text.trim().toLowerCase();
                    final selectedLabel = _selectedSeason.label.toLowerCase();

                    for (final group in allProductGroupsMap.values) {
                      final mainProduct = group.first;
                      final nameMatch =
                          mainProduct.productName.toLowerCase().contains(query);
                      if (!nameMatch) continue;
                      if (_selectedSeason == SeasonFilter.all) {
                        filteredProductGroups.add(group);
                      } else {
                        final List<Product> shadesMatchingFilter =
                            group.where((shade) {
                          return shade.seasonName
                              .toLowerCase()
                              .contains(selectedLabel);
                        }).toList();

                        if (shadesMatchingFilter.isNotEmpty) {
                          filteredProductGroups.add(shadesMatchingFilter);
                        }
                      }
                    }
                    return ProductGrid(productGroups: filteredProductGroups);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search Product',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF7F8F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildSeasonFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _seasonFilters.map((season) {
          final isSelected = _selectedSeason == season;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(season.label),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (selected) {
                if (!selected) return;
                setState(() {
                  _selectedSeason = season;
                });
              },
              selectedColor: Colors.black,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
