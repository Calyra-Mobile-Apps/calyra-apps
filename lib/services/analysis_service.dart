// Lokasi file: lib/services/analysis_service.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/models/quiz_session.dart';

class AnalysisService {
  AnalysisResult analyze(QuizSession session, {DateTime? analysisDate}) {
    final answers = session.answers;
    final undertone = answers[QuizKeys.undertone] ?? 'neutral';
    final skintone =
        answers[QuizKeys.skintone] ?? '0'; // Disimpan sebagai string ID

    // Mengambil data season murni (cth: "Spring", "Autumn") dari provider
    final season = answers[QuizKeys.seasonalColor] ?? 'unknown';

    // Langsung simpan data secara terpisah
    return AnalysisResult(
      seasonResult: season, // Menyimpan "Spring", "Autumn", etc.
      undertone: undertone, // Menyimpan "warm" atau "cool"
      skintone: skintone,
      analysisDate: analysisDate ?? DateTime.now(),
    );
  }

  // --- LOGIKA UTAMA DIPERBARUI DI SINI ---
  String _resolveSeason(String undertone, String seasonalResult) {
    // Fallback jika seasonalResult kosong
    if (seasonalResult == 'unknown' || seasonalResult.isEmpty) {
      if (undertone == 'warm') return 'Warm Autumn'; // Default untuk warm
      if (undertone == 'cool') return 'Cool Winter'; // Default untuk cool
      return 'Neutral';
    }

    // Menggabungkan hasil undertone dengan hasil pilihan mayoritas seasonal.
    if (undertone == 'warm') {
      if (seasonalResult == 'Spring') {
        return 'Warm Spring';
      } else if (seasonalResult == 'Autumn') {
        return 'Warm Autumn';
      }
    }

    if (undertone == 'cool') {
      if (seasonalResult == 'Summer') {
        return 'Cool Summer';
      } else if (seasonalResult == 'Winter') {
        return 'Cool Winter';
      }
    }

    // Fallback jika ada kombinasi yang tidak terduga
    return seasonalResult;
  }
}
