// Lokasi file: lib/screens/home/home_screen.dart

import 'dart:math';

import 'package:calyra/data/brand_data.dart';
import 'package:calyra/data/season_category_data.dart';
import 'package:calyra/models/brand_info.dart';
import 'package:calyra/models/season_category.dart';
import 'package:calyra/screens/brand/brand_catalog_screen.dart';
import 'package:calyra/screens/home/category_detail_screen.dart';
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
          return _SeasonalCard(
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
        return _BrandCard(
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

class _SeasonalCard extends StatelessWidget {
  const _SeasonalCard({required this.category, required this.onTap});

  final SeasonCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: SizedBox(
            width: 112,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: Image.asset(
                      category.iconPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF0D1B2A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({
    required this.brandName,
    required this.imageUrl,
    required this.logoPath,
    required this.onTap,
  });

  final String brandName;
  final String imageUrl;
  final String logoPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _BackgroundImage(
              imageUrl: imageUrl,
              fallbackLabel: brandName,
            ),
            const _GrainOverlay(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  logoPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({required this.imageUrl, required this.fallbackLabel});

  final String imageUrl;
  final String fallbackLabel;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withValues(alpha: 0.25),
        BlendMode.darken,
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: Text(
              fallbackLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GrainOverlay extends StatelessWidget {
  const _GrainOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GrainPainter(),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  static const int _particleCount = 1200;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(1337);
    final paint = Paint();
    for (var i = 0; i < _particleCount; i++) {
      final opacity = 0.015 + random.nextDouble() * 0.03;
      final radius = 0.4 + random.nextDouble() * 0.6;
  paint.color = Colors.white.withValues(alpha: opacity);
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
