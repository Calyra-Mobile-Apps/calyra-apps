// Lokasi file: lib/screens/product/product_detail_screen.dart

import 'package:calyra/models/product.dart';
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
                  Text(
                    currentProduct.productName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: SizedBox(
                      height: 250,
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
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.productShades.length,
                      (index) => _buildDotIndicator(index == _currentPage),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  const Text(
                    'Shade Details',
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
                onPressed: () => _launchURL(context, currentProduct),
                child: const Text('Find on Shopee',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadeView(BuildContext context, Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.network(
            product.imageSwatchUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image,
                    size: 80, color: Colors.grey),
              );
            },
          ),
        ),
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
          border: Border.all(color: Colors.grey.shade300, width: 1)),
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
