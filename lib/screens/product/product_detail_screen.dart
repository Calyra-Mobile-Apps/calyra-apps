// Lokasi file: lib/screens/product/product_detail_screen.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/widgets/custom_product_image.dart';
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
    final String? urlString = product.linkProduct;
    if (urlString != null && urlString.isNotEmpty) {
      try {
        final Uri url = Uri.parse(urlString);
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No product link available')),
        );
      }
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    currentProduct.productName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
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
                  if (currentProduct.skintoneGroupIds.isNotEmpty &&
                      !currentProduct.skintoneGroupIds.contains(0))
                    _buildDetailRow('For Skintone',
                        'ID ${currentProduct.skintoneGroupIds.join(", ")}'),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF15A24),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _launchURL(context, currentProduct),
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Find on Shopee',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomProductImage(
        imageUrl: product.imageSwatchUrl,
        fit: BoxFit.contain,
      ),
    );
  }

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
