// Lokasi file: lib/screens/home/home_screen.dart

import 'package:calyra/data/brand_data.dart';
import 'package:calyra/data/season_category_data.dart';
import 'package:calyra/models/brand_info.dart';
import 'package:calyra/models/product.dart';
import 'package:calyra/models/season_category.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/models/user_model.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:calyra/screens/brand/brand_catalog_screen.dart';
import 'package:calyra/screens/home/category_detail_screen.dart';
import 'package:calyra/widgets/brand_card.dart';
import 'package:calyra/widgets/product_grid.dart';
import 'package:calyra/widgets/seasonal_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  late Future<Map<String, List<Product>>> _allProductsFuture;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _allProductsFuture = _fetchAllProducts();

    _searchController.addListener(() {
      final bool isSearching = _searchController.text.isNotEmpty;
      if (isSearching != _isSearching) {
        setState(() {
          _isSearching = isSearching;
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi Fetch All Products (Hanya dipakai saat Search)
  Future<Map<String, List<Product>>> _fetchAllProducts() async {
    final response = await _firestoreService.getAllProducts();

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
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN HEADER & SEARCH (FIXED TOP) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isSearching) _buildSearchHeader() else _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- KONTEN UTAMA (SCROLLABLE) ---
            Expanded(
              child: _isSearching
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildSearchResults(),
                    )
                  : _buildDefaultContent(),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER DENGAN NAMA USER (REAL-TIME STREAM) ---
  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return _buildWelcomeText('Calyra');
    }

    return StreamBuilder<UserModel?>(
      stream: _firestoreService.getUserStream(user.uid),
      builder: (context, snapshot) {
        String displayName = 'Calyra';

        if (snapshot.hasData && snapshot.data != null) {
          final fullName = snapshot.data!.name;
          if (fullName.isNotEmpty) {
            displayName = fullName.split(' ').first;
          }
        }

        return _buildWelcomeText(displayName);
      },
    );
  }

  Widget _buildWelcomeText(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello $name,',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B2A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Let's find your Personal Color Analysis!",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _searchController.clear();
            FocusScope.of(context).unfocus();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
        const Text(
          'Search Results',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B2A),
          ),
        ),
      ],
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
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // --- KONTEN DEFAULT (TANPA TAB FILTER) ---
  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. SEASONAL PICKS (Kartu Musim)
          _buildSectionTitle(
            'Seasonal Picks',
            'Discover makeup based on your seasonal color',
          ),
          const SizedBox(height: 16),
          _buildSeasonalPicks(context),

          const SizedBox(height: 24),

          // 2. BRAND MAKEUP
          _buildSectionTitle(
            'Brand Makeup',
            'Explore trusted brands for styles that suit you best',
          ),
          const SizedBox(height: 16),
          _buildBrandMakeup(context),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final String query = _searchController.text.trim().toLowerCase();

    return FutureBuilder<Map<String, List<Product>>>(
      future: _allProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products available.'));
        }

        final allProductGroupsMap = snapshot.data!;
        if (query.isEmpty) {
          return const Center(child: Text('Please enter a search term.'));
        }

        final List<String> keywords =
            query.split(' ').where((k) => k.isNotEmpty).toList();

        final filteredProductGroups = allProductGroupsMap.values.where((group) {
          final mainProduct = group.first;
          final String searchableText = [
            mainProduct.productName,
            mainProduct.brandName,
            mainProduct.productType,
            ...group.map((p) => p.shadeName),
          ].join(' ').toLowerCase();
          return keywords.every((keyword) => searchableText.contains(keyword));
        }).toList();

        if (filteredProductGroups.isEmpty) {
          return Center(child: Text('No products found for "$query"'));
        }

        return ProductGrid(
          productGroups: filteredProductGroups,
          padding: const EdgeInsets.only(bottom: 100.0),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B2A),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonalPicks(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: seasonCategories.length,
        itemBuilder: (context, index) {
          final SeasonCategory category = seasonCategories[index];
          return SeasonalCard(
            category: category,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryDetailScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBrandMakeup(BuildContext context) {
    return GridView.builder(
      itemCount: featuredBrands.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final BrandInfo brand = featuredBrands[index];
        return BrandCard(
          brandName: brand.name,
          imageUrl: brand.imageUrl,
          logoPath: brand.homeLogoPath ?? brand.logoPath,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BrandCatalogScreen(
                  brandLogoPath: brand.logoPath,
                  brandName: brand.name,
                ),
              ),
            );
          },
        );
      },
    );
  }
}