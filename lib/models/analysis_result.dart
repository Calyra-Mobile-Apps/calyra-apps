// Lokasi file: lib/models/analysis_result.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalysisResult {
  final String seasonResult;
  final String undertone;
  final String skintone;
  final DateTime analysisDate;
  // Anda bisa tambahkan List<String> palette jika menyimpannya juga

  AnalysisResult({
    required this.seasonResult,
    required this.undertone,
    required this.skintone,
    required this.analysisDate,
  });

  // Factory constructor untuk membuat objek dari data Firestore
  factory AnalysisResult.fromFirestore(Map<String, dynamic> data) {
    return AnalysisResult(
      seasonResult: data['seasonResult'] ?? 'Unknown',
      undertone: data['undertone'] ?? 'Unknown',
      skintone: data['skintone'] ?? 'Unknown',
      analysisDate: (data['analysisDate'] as Timestamp).toDate(),
    );
  }
}
