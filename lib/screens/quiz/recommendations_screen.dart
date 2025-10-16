import 'package:flutter/material.dart';

// --- KONSTANTA WARNA KOTAK ---
const Color kItemBoxColor = Color(0xFFF3F3F3); // warna background kotak yang sama

// --- DATA MODEL SIMULASI ---
class Shade {
  final String code;
  final String description;
  final Color baseColor;
  final Color topColor;

  const Shade(this.code, this.description, this.baseColor, this.topColor);
}

class Product {
  final String name;
  final String imagePath;
  final Color bgColor;

  const Product(this.name, this.imagePath, this.bgColor);
}

// --- WIDGET KOMPONEN KUSTOM ---
class _CategoryPill extends StatelessWidget {
  final String title;
  const _CategoryPill({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _ShadeItem extends StatelessWidget {
  final Shade shade;
  const _ShadeItem({required this.shade});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: SizedBox(
        width: 110,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Kotak luar memakai warna yang sama (kItemBoxColor)
                Container(
                  height: 120,
                  width: 110,
                  decoration: BoxDecoration(
                    color: kItemBoxColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                // Circle tetap menunjukkan shade/top color
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: shade.topColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      shade.code,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              shade.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: SizedBox(
        width: 110,
        child: Column(
          children: [
            // Kotak produk memakai warna yang sama (kItemBoxColor)
            Container(
              height: 120,
              width: 110,
              decoration: BoxDecoration(
                color: kItemBoxColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    product.imagePath,
                    fit: BoxFit.contain,
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HALAMAN UTAMA KATALOG ---
class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  final List<Shade> shades = const [
    Shade(
      '#23W',
      'Shade for Base Complexion',
      Color(0xFFD4D4D4),
      Color(0xFFE9D0B4),
    ),
    Shade(
      '#23W',
      'Shade for Concealer',
      Color(0xFFD4D4D4),
      Color(0xFFE9D0B4),
    ),
    Shade(
      '#23W',
      'Shade for Bronzer or Contour',
      Color(0xFFBCA78E),
      Color(0xFFE5C8A7),
    ),
    Shade(
      '#XXW',
      'Extra Sample Shade',
      Color(0xFFD4D4D4),
      Color(0xFFE9D0B4),
    ),
  ];

  // Hanya 3 produk liquid sesuai permintaan
  final List<Product> liquidProducts = const [
    Product(
      'Colorfit Matte Foundation',
      'assets/images/wardah-foundation.png',
      kItemBoxColor,
    ),
    Product(
      'Colorfit Matte Cushion',
      'assets/images/wardah-cushion.png',
      kItemBoxColor,
    ),
    Product(
      'Colorfit Matte 5D Blur Cushion',
      'assets/images/wardah-cushion-1.png',
      kItemBoxColor,
    ),
  ];

  // 3 produk powder (gambar berbeda)
  final List<Product> powderProducts = const [
    Product(
      'Wardah Loose Powder',
      'assets/images/wardah-powder.png',
      kItemBoxColor,
    ),
    Product(
      'Wardah Two Way Cake',
      'assets/images/wardah-powder-2.png',
      kItemBoxColor,
    ),
    Product(
      'Wardah Compact Powder',
      'assets/images/wardah-powder-3.png',
      kItemBoxColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // hitung inset bawah untuk memberi ruang ekstra agar tidak overflow
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wardah Spotlight',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,

      // body tetap di dalam SafeArea
      body: SafeArea(
        child: SingleChildScrollView(
          // cukup beri padding kecil di bawah; ruang utama disediakan oleh bottomNavigationBar
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wardah for Your Warm Spring Palette',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Explore products picked just for you.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: _CategoryPill(title: 'Best Shade'),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: shades.length,
                  itemBuilder: (context, index) {
                    return _ShadeItem(shade: shades[index]);
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: _CategoryPill(title: 'Liquid Complexion'),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: liquidProducts.length,
                  itemBuilder: (context, index) {
                    return _ProductItem(product: liquidProducts[index]);
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: _CategoryPill(title: 'Powder Complexion'),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: powderProducts.length,
                  itemBuilder: (context, index) {
                    return _ProductItem(product: powderProducts[index]);
                  },
                ),
              ),

              // spacer kecil saja (padding utama di bawah disediakan oleh bottomNavigationBar)
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),

      // reservasi ruang bawah untuk gesture bar / inset agar konten tidak tercrop
      bottomNavigationBar: SizedBox(height: bottomInset),
    );
  }
}