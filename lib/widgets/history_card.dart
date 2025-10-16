// Lokasi file: lib/widgets/history_card.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calyra/data/palette_assets.dart'; 

class HistoryCard extends StatelessWidget {
  final AnalysisResult result;
  final VoidCallback onTap;

  const HistoryCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  // Helper untuk mendapatkan asset path berdasarkan Season Result
  String _getSeasonPaletteAsset(String season) {
    // Memecah Season Result (contoh: 'Cool Summer' -> 'Summer')
    final seasonType = season.split(' ').last; 
    
    switch (seasonType) {
      case 'Spring':
        return PaletteAssets.spring;
      case 'Summer':
        return PaletteAssets.summer;
      case 'Autumn':
        return PaletteAssets.autumn;
      case 'Winter':
        return PaletteAssets.winter;
      default:
        // Jika tidak dikenali, gunakan fallback atau salah satu yang umum
        return PaletteAssets.unknown; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _getSeasonPaletteAsset(result.seasonResult);
    final formattedDate = DateFormat('d MMMM yyyy').format(result.analysisDate);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Side Palette Image Bar (REVISI DI SINI)
            Container(
              width: 12,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                // Mengganti Gradient dengan Image Asset
                image: DecorationImage(
                  image: AssetImage(assetPath),
                  fit: BoxFit.cover, // Memastikan gambar mengisi area
                  repeat: ImageRepeat.repeatY,
                ),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bar_chart, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Personal Color Analysis',
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      result.seasonResult, // Season Result
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            // Tombol Check Details
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Check details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black, 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}