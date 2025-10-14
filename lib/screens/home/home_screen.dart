// Lokasi file: lib/screens/home/home_screen.dart

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
                // 1. Header
                _buildHeader(),
                const SizedBox(height: 24),

                // 2. Search Bar
                _buildSearchBar(),
                const SizedBox(height: 24),

                // 3. Seasonal Picks
                _buildSectionTitle('Seasonal Picks', 'Discover makeup based on your seasonal color'),
                const SizedBox(height: 16),
                _buildSeasonalPicks(),
                const SizedBox(height: 24),

                // 4. Brand Makeup
                _buildSectionTitle('Brand Makeup', 'Explore trusted brands for styles that suit you best'),
                const SizedBox(height: 16),
                _buildBrandMakeup(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk Header
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

  // Widget untuk Search Bar
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

  // Widget untuk Judul Section (Seasonal Picks & Brand Makeup)
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

  // Widget untuk Seasonal Picks
  Widget _buildSeasonalPicks() {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _SeasonalCard(icon: Icons.wb_sunny_outlined, label: 'Summer'),
          _SeasonalCard(icon: Icons.park_outlined, label: 'Autumn'),
          _SeasonalCard(icon: Icons.filter_vintage_outlined, label: 'Spring'),
          _SeasonalCard(icon: Icons.ac_unit_outlined, label: 'Winter'),
        ],
      ),
    );
  }

  // Widget untuk Brand Makeup
  Widget _buildBrandMakeup() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.8,
      children: const [
        // Gunakan placeholder gambar jika aset belum ada
        _BrandCard(brandName: 'Wardah', imageUrl: 'https://placehold.co/300x400/E9A4A1/FFFFFF?text=Wardah'),
        _BrandCard(brandName: 'Emina', imageUrl: 'https://placehold.co/300x400/D4B4C3/FFFFFF?text=Emina'),
        _BrandCard(brandName: 'Make Over', imageUrl: 'https://placehold.co/300x400/C8A995/FFFFFF?text=Make+Over'),
        _BrandCard(brandName: 'Somethinc', imageUrl: 'https://placehold.co/300x400/A2B4C1/FFFFFF?text=Somethinc'),
      ],
    );
  }
}

// Widget internal untuk kartu Seasonal
class _SeasonalCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SeasonalCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.black54),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// Widget internal untuk kartu Brand
class _BrandCard extends StatelessWidget {
  final String brandName;
  final String imageUrl;

  const _BrandCard({required this.brandName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            // Error handling jika gambar gagal dimuat
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: Center(child: Text(brandName, style: const TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.bold))),
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            child: Text(
              brandName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
