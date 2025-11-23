// Lokasi file: lib/screens/product/product_detail_screen.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/widgets/custom_product_image.dart'; // Pastikan widget ini ada
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productShades});
  final List<Product> productShades;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;

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

  // Fungsi untuk membuka link Shopee
  Future<void> _launchURL(BuildContext context, Product product) async {
    // Cek apakah linkProduct ada dan tidak kosong
    final String? urlString = product.linkProduct;

    if (urlString != null && urlString.isNotEmpty) {
      try {
        final Uri url = Uri.parse(urlString);
        // Coba launch dengan mode external application (browser/shopee app)
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not launch $urlString')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Product URL format')),
          );
        }
      }
    } else {
      // Jika link kosong/null
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No product link available')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Produk yang sedang aktif di slider
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Nama Produk
                  Text(
                    currentProduct.productName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Slider Gambar Produk (PageView)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 320,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: widget.productShades.length,
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

                      // Tombol Panah (Jika lebih dari 1 shade)
                      if (widget.productShades.length > 1) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _buildArrowButton(isLeft: true),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildArrowButton(isLeft: false),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Nama Shade & Brand
                  Text(
                    currentProduct.shadeName,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${currentProduct.brandName}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  
                  const Divider(height: 32, thickness: 1),
                  
                  // Detail Produk
                  const Text(
                    'Shade Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Category', currentProduct.productType),
                  _buildDetailRow('Undertone', currentProduct.undertoneName),
                  _buildDetailRow('Season', currentProduct.seasonName),
                  // Tampilkan Skintone Group ID jika ada dan tidak 0
                  if (currentProduct.skintoneGroupId != 0)
                     _buildDetailRow('For Skintone', 'ID ${currentProduct.skintoneGroupId}'),
                  
                  // Detail harga (jika ada di model Anda, tambahkan di sini)
                  // Contoh: _buildDetailRow('Price', 'Rp ...'),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Tombol Belanja (Find on Shopee)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF15A24), // Warna Shopee
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _launchURL(context, currentProduct),
                icon: const Icon(Icons.shopping_cart_outlined), 
                label: const Text(
                  'Find on Shopee', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Tampilan Gambar (Menggunakan CustomProductImage)
  Widget _buildShadeView(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      // --- PERUBAHAN UTAMA: Pakai CustomProductImage agar aman ---
      child: CustomProductImage(
        imageUrl: product.imageSwatchUrl, // Pastikan nama field ini benar di model Anda
        fit: BoxFit.contain,
      ),
      // -----------------------------------------------------------
    );
  }
  
  // Widget Tombol Panah Kiri/Kanan
  Widget _buildArrowButton({required bool isLeft}) {
    final bool isVisible = isLeft
        ? _currentPage > 0
        : _currentPage < widget.productShades.length - 1;

    return Visibility(
      visible: isVisible,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            isLeft ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
            size: 20,
          ),
          color: Colors.white,
          onPressed: () {
            if (isLeft) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ),
    );
  }
  
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
