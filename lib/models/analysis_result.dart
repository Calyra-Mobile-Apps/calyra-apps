// Lokasi file: lib/models/analysis_result.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalysisResult {
  final String seasonResult;
  final String undertone;
  final String skintone;
  final DateTime analysisDate;

  AnalysisResult({
    required this.seasonResult,
    required this.undertone,
    required this.skintone,
    required this.analysisDate,
  });

  factory AnalysisResult.fromFirestore(Map<String, dynamic> data) {
    final timestamp = data['analysisDate'];
    return AnalysisResult(
      seasonResult: data['seasonResult'] as String? ?? 'Unknown',
      undertone: data['undertone'] as String? ?? 'Unknown',
      skintone: data['skintone'] as String? ?? 'Unknown',
      analysisDate:
          timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seasonResult': seasonResult,
      'undertone': undertone,
      'skintone': skintone,
      'analysisDate': Timestamp.fromDate(analysisDate),
    };
  }

  AnalysisResult copyWith({
    String? seasonResult,
    String? undertone,
    String? skintone,
    DateTime? analysisDate,
  }) {
    return AnalysisResult(
      seasonResult: seasonResult ?? this.seasonResult,
      undertone: undertone ?? this.undertone,
      skintone: skintone ?? this.skintone,
      analysisDate: analysisDate ?? this.analysisDate,
    );
  }
}
