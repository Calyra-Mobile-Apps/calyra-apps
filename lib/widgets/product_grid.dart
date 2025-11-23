// Lokasi file: lib/widgets/product_grid.dart

import 'package:calyra/models/product.dart';
import 'package:calyra/screens/product/product_detail_screen.dart';
import 'package:calyra/widgets/custom_product_image.dart'; // <-- IMPORT BARU
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final List<List<Product>> productGroups;
  final EdgeInsetsGeometry padding;

  const ProductGrid({
    super.key,
    required this.productGroups,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: productGroups.length,
      itemBuilder: (context, index) {
        final group = productGroups[index];
        final mainProduct = group.first;
        final shadeCount = group.length;
        
        // Ambil nama shade
        String shadeText = mainProduct.shadeName;
        if (shadeCount > 1) {
           // Jika lebih dari 1 shade, gabungkan namanya atau tulis "+X more"
           shadeText = group.map((e) => e.shadeName).join(', ');
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  productShades: group,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BAGIAN GAMBAR DIGANTI ---
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomProductImage( // <-- PAKAI WIDGET BARU
                        imageUrl: mainProduct.imageSwatchUrl,
                      ),
                    ),
                  ),
                ),
                // -----------------------------
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mainProduct.brandName,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mainProduct.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shadeCount > 1 ? '$shadeCount Shades Available' : 'Shade: $shadeText',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                    ],
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