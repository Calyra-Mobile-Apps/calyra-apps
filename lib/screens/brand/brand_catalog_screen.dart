// Lokasi file: lib/screens/brand/brand_catalog_screen.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/models/season_filter.dart';
import 'package:calyra/services/firestore_service.dart'; // <-- 1. IMPORT SERVICE
import 'package:calyra/widgets/product_grid.dart';
import 'package:flutter/material.dart';

// 2. UBAH PARAMETER CONSTRUCTOR
class BrandCatalogScreen extends StatefulWidget {
  const BrandCatalogScreen({
    super.key,
    required this.brandLogoPath,
    required this.brandName, // Diubah dari 'products' menjadi 'brandName'
  });

  final String brandLogoPath;
  final String brandName;

  @override
  State<BrandCatalogScreen> createState() => _BrandCatalogScreenState();
}

class _BrandCatalogScreenState extends State<BrandCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<SeasonFilter> _seasonFilters = SeasonFilter.values;
  SeasonFilter _selectedSeason = SeasonFilter.summer;

  // 3. VARIABLE UNTUK MENAMPUNG PROSES PENGAMBILAN DATA
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // 4. PANGGIL FUNGSI UNTUK MENGAMBIL DATA SAAT HALAMAN DIBUKA
    _productsFuture = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final firestoreService = FirestoreService();
    // Memanggil fungsi dari service dengan nama brand
    final response = await firestoreService.getProductsByBrandName(widget.brandName);

    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      // Menampilkan pesan error jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to load products')),
      );
      // Mengembalikan list kosong jika terjadi error
      return [];
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
              // 5. GUNAKAN FUTUREBUILDER UNTUK MENAMPILKAN DATA
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    // Saat data masih dimuat, tampilkan loading indicator
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Jika ada error
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    // Jika tidak ada data atau data kosong
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    }

                    // Jika data berhasil didapat, filter dan tampilkan
                    final allProducts = snapshot.data!;
                    final filteredProducts = allProducts.where((product) {
                      final query = _searchController.text.trim().toLowerCase();
                      final seasonMatch = product.seasonName.toLowerCase().contains(_selectedSeason.label.toLowerCase());
                      
                      if (query.isEmpty) {
                        return seasonMatch;
                      }
                      
                      final nameMatch = product.productName.toLowerCase().contains(query);
                      return nameMatch && seasonMatch;
                    }).toList();

                    return ProductGrid(products: filteredProducts);
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
      // Memanggil setState agar UI di-rebuild saat user mengetik
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
  
  // Hapus getter `filteredProducts` yang lama karena sudah ditangani di dalam FutureBuilder
}