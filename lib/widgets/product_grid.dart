// Lokasi file: lib/widgets/product_grid.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/screens/product/product_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.productGroups});

  final List<List<Product>> productGroups;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: productGroups.length,
      itemBuilder: (context, index) {
        final productGroup = productGroups[index];
        final mainProduct = productGroup.first;

        final String firstSeason = mainProduct.seasonName;
        final bool isFilteredBySeason = productGroup
            .every((p) => p.seasonName == firstSeason && firstSeason.isNotEmpty);

        String shadeText;
        if (isFilteredBySeason) {
          shadeText = '${productGroup.length} ${firstSeason} Shades';
        } else {
          shadeText = '${productGroup.length} Shades';
        }

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(productShades: productGroup),
              ),
            );
          },
          // --- MODIFIKASI PADA CARD DI SINI ---
          child: Card(
            color: Colors.white, // 1. Warna kartu diatur menjadi putih bersih
            shadowColor: Colors.black.withOpacity(0.1), // 2. Warna bayangan diperhalus
            clipBehavior: Clip.antiAlias,
            elevation: 4, // 3. Elevasi sedikit dinaikkan untuk shadow yang lebih jelas
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    mainProduct.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF0F0F0), // Warna placeholder diubah
                        child: const Center(
                            child: Icon(Icons.image_not_supported_outlined,
                                size: 40, color: Colors.grey)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    mainProduct.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, bottom: 12.0, right: 12.0),
                  child: Text(
                    shadeText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}