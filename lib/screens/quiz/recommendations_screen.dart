import 'package:flutter/material.dart';

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
                Container(
                  height: 120,
                  width: 110,
                  decoration: BoxDecoration(
                    color: shade.baseColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
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
                        fontSize: 20,
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
            Container(
              height: 120,
              width: 110,
              decoration: BoxDecoration(
                color: product.bgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  product.imagePath,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
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

  final List<Product> liquidProducts = const [
    Product(
      'Colorfit Matte Foundation',
      'Image: Tube',
      Color(0xFFE9D0B4),
    ),
    Product(
      'Colorfit Matte Foundation',
      'Image: Cushion',
      Color(0xFFE9D0B4),
    ),
    Product(
      'Colorfit Matte Foundation',
      'Image: Compact',
      Color(0xFFD3E0C6),
    ),
    Product(
      'Colorfit Matte Foundation',
      'Image: Sample',
      Color(0xFFE9D0B4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wardah Spotlight',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore products picked just for you.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
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
                itemCount: liquidProducts.length,
                itemBuilder: (context, index) {
                  return _ProductItem(product: liquidProducts[index]);
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}