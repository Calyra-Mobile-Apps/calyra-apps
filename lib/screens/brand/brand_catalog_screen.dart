import 'package:calyra/models/product.dart';
import 'package:calyra/models/season_filter.dart';
import 'package:calyra/widgets/product_grid.dart';
import 'package:flutter/material.dart';

class BrandCatalogScreen extends StatefulWidget {
  const BrandCatalogScreen({
    super.key,
    required this.brandLogoPath,
    required this.products,
  });

  final String brandLogoPath;
  final List<Product> products;

  @override
  State<BrandCatalogScreen> createState() => _BrandCatalogScreenState();
}

class _BrandCatalogScreenState extends State<BrandCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<SeasonFilter> _seasonFilters = SeasonFilter.values;
  SeasonFilter _selectedSeason = SeasonFilter.summer;

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
                child: ProductGrid(products: filteredProducts),
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

  List<Product> get filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return widget.products.where((product) {
      if (query.isEmpty) return true;
      return product.name.toLowerCase().contains(query);
    }).toList();
  }
}
