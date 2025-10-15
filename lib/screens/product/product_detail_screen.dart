// Lokasi file: lib/screens/product/product_detail_screen.dart

import 'package:calyra/models/product.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget { // Ubah menjadi StatefulWidget
  // UBAH PARAMETER MENJADI LIST OF SHADES
  const ProductDetailScreen({super.key, required this.productShades});

  final List<Product> productShades;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0; // State untuk melacak shade yang sedang aktif

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helper untuk membuka URL - menggunakan shade yang sedang aktif
  Future<void> _launchURL(BuildContext context, Product product) async {
    if (product.linkProduct != null && product.linkProduct!.isNotEmpty) {
      final Uri url = Uri.parse(product.linkProduct!);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch ${product.linkProduct!}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No product link available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil shade yang sedang ditampilkan
    final Product currentProduct = widget.productShades[_currentPage];
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Product Detail',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk (Teks tetap)
                  Text(
                    currentProduct.productName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Container untuk PageView/Slider (Gambar Shade)
                  Center(
                    child: SizedBox(
                      height: 250, 
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.productShades.length,
                        // Update state saat halaman berubah
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final product = widget.productShades[index];
                          return _buildShadeView(context, product);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Indikator Halaman (Dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.productShades.length,
                      (index) => _buildDotIndicator(index == _currentPage),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nama Shade & Brand
                  Text(
                    currentProduct.shadeName, // Nama shade saat ini
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${currentProduct.brandName}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Divider(height: 32, thickness: 1),

                  // Detail Produk (Menampilkan detail shade yang aktif)
                  const Text(
                    'Shade Details', // Ubah judul
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Category', currentProduct.productType),
                  _buildDetailRow('Undertone', currentProduct.undertoneName),
                  _buildDetailRow('Season', currentProduct.seasonName),
                  _buildDetailRow('For Skintone', currentProduct.skintoneName),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Tombol Shopee (Diletakkan di bawah Expanded agar tetap terlihat)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF15A24),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Gunakan currentProduct untuk link
                onPressed: () => _launchURL(context, currentProduct),
                child: const Text('Find on Shopee', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan satu shade (image)
  Widget _buildShadeView(BuildContext context, Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gambar Produk
        Expanded(
          child: Image.network(
            product.imageSwatchUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
              );
            },
          ),
        ),
        // Swatch warna
        _buildColorSwatch(product.colorHex),
      ],
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
  
  // Widget untuk menampilkan swatch warna
  Widget _buildColorSwatch(String colorHex) {
    Color color;
    try {
      String hex = colorHex.startsWith('0x') ? colorHex.substring(2) : colorHex;
      if (hex.length == 6) {
        hex = 'FF' + hex;
      }
      color = Color(int.parse(hex, radix: 16));
    } catch (e) {
      color = Colors.grey; 
    }

    return Container(
      width: 40,
      height: 15,
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 1)
      ),
    );
  }

  // Widget helper untuk baris detail (tidak berubah)
  Widget _buildDetailRow(String title, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}