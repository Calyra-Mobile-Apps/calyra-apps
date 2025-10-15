// Lokasi file: lib/screens/home/home_screen.dart

import 'package:calyra/data/brand_data.dart';
import 'package:calyra/data/season_category_data.dart';
import 'package:calyra/models/brand_info.dart';
import 'package:calyra/models/season_category.dart';
import 'package:calyra/screens/brand/brand_catalog_screen.dart';
import 'package:calyra/screens/home/category_detail_screen.dart';
import 'package:calyra/widgets/brand_card.dart';
import 'package:calyra/widgets/seasonal_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildSectionTitle(
                  'Seasonal Picks',
                  'Discover makeup based on your seasonal color',
                ),
                const SizedBox(height: 16),
                _buildSeasonalPicks(context),
                const SizedBox(height: 24),
                _buildSectionTitle(
                  'Brand Makeup',
                  'Explore trusted brands for styles that suit you best',
                ),
                const SizedBox(height: 16),
                _buildBrandMakeup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello Calyra,',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B2A),
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Let's find your Personal Color Analysis!",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
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
                  products: brand.products,
                ),
              ),
            );
          },
        );
      },
    );
  }
}


