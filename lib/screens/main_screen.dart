// Lokasi file: lib/screens/main_screen.dart

import 'package:calyra/screens/home/home_screen.dart';
import 'package:calyra/screens/profile/profile_screen.dart';
import 'package:calyra/screens/quiz/take_selfie_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const TakeSelfieScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Menggunakan IndexedStack untuk menjaga state setiap halaman
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          if (_selectedIndex != 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: _CustomBottomNavBar(
                  selectedIndex: _selectedIndex,
                  onItemSelected: _onItemTapped,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom Bottom Navigation Bar Widget
class _CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const _CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  // Data untuk navigasi (label, icon, index)
  final List<Map<String, dynamic>> items = const [
    {'label': 'Home', 'icon': Icons.home_outlined, 'activeIcon': Icons.home},
    // Mengubah label menjadi 'Face Scan' sesuai gambar terbaru
    {
      'label': 'Face Scan',
      'icon': Icons.sentiment_satisfied_outlined,
      'activeIcon': Icons.sentiment_satisfied
    },
    {
      'label': 'Profile',
      'icon': Icons.person_outline,
      'activeIcon': Icons.person
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Ukuran Ikon standar
    const double iconSize = 24.0;
    // Padding Lingkaran standar (seharusnya: iconSize + padding * 2 = 48)
    const double circlePadding = 14.0;

    return Container(
      // 1. Floating Effect & Ukuran: Memberikan margin agar 'menggantung'
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        // Menggunakan MainAxisAlignment.spaceEvenly atau Center
        // agar tombol-tombol non-aktif (lingkaran) tetap memiliki ruang
        // dan tombol aktif (pill) bisa mengambil ruang yang dibutuhkan.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final isSelected = index == selectedIndex;
          final item = items[index];

          return GestureDetector(
            onTap: () => onItemSelected(index),
            // Mengganti Padding luar dan Expanded dengan SizedBox.expand
            // untuk mengontrol lebar item aktif.
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,

              // 2. Kontrol Bentuk & Lebar Adaptif
              // Lebar ditentukan oleh isSelected:
              // - Jika terpilih: Padding horizontal lebih besar, menjadi bentuk pill.
              // - Jika tidak terpilih: Padding sama sisi, menjadi lingkaran.
        padding: isSelected
          ? const EdgeInsets.symmetric(horizontal: 56, vertical: 12)
          : const EdgeInsets.all(circlePadding),

              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),

              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // Memastikan lebar pill hanya seukuran konten
                children: [
                  Icon(
                    isSelected ? item['activeIcon'] : item['icon'],
                    color: Colors.white,
                    size: iconSize,
                  ),

                  // 3. Teks hanya muncul jika selected
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
