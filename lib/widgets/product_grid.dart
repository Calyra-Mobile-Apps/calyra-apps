// Lokasi file: lib/widgets/product_grid.dart

import 'package:calyra/models/product.dart';
// Import yang diperlukan
import 'package:calyra/models/season_filter.dart';
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
        final bool isFilteredBySeason = productGroup.every(
            (p) => p.seasonName == firstSeason && firstSeason.isNotEmpty);

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
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
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
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                          child: Icon(Icons.broken_image,
                              size: 60, color: Colors.grey));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    mainProduct.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
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

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
