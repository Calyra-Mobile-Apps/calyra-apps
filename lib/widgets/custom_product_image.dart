// Lokasi file: lib/widgets/custom_product_image.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomProductImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const CustomProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  // --- FUNGSI PROXY SAKTI ---
  String _getProxyUrl(String url) {
    if (url.isEmpty) return '';
    
    // Bersihkan URL dari spasi
    var cleanUrl = url.trim();
    
    // Hapus parameter aneh-aneh di belakang (seperti @resize...)
    if (cleanUrl.contains('@')) {
      cleanUrl = cleanUrl.split('@')[0];
    }

    // Hapus skema https:// agar bisa ditempel ke url proxy
    String urlWithoutScheme = cleanUrl
        .replaceFirst('https://', '')
        .replaceFirst('http://', '');

    // Gunakan layanan wsrv.nl sebagai perantara (Proxy)
    // n = -1 artinya jangan dikompres (kualitas asli)
    return 'https://wsrv.nl/?url=$urlWithoutScheme&n=-1';
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan URL Proxy, bukan URL asli
    final proxyUrl = _getProxyUrl(imageUrl);

    if (imageUrl.isEmpty) {
      return _buildFallbackImage();
    }

    return CachedNetworkImage(
      imageUrl: proxyUrl, // <--- LOAD DARI PROXY
      fit: fit,
      width: width,
      height: height,
      
      // Tidak perlu header aneh-aneh lagi karena kita minta ke wsrv.nl
      httpHeaders: const {
        "User-Agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
      },

      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[300]),
        ),
      ),

      errorWidget: (context, url, error) {
        // debugPrint("❌ Masih Gagal: $url | Asli: $imageUrl");
        return _buildFallbackImage();
      },
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[100],
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined, color: Colors.grey[400], size: 24),
          const SizedBox(height: 4),
          Text(
            'No Image',
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          )
        ],
      ),
    );
  }
}
