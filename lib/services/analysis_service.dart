// Lokasi file: lib/services/analysis_service.dart

class AnalysisService {
  // Fungsi ini mengambil semua jawaban dan mengembalikan hasil berupa String
  String getAnalysisResult(Map<String, String> answers) {
    // Ambil jawaban dari map
    final String undertone = answers['undertone'] ?? '';
    final String skintone = answers['skintone'] ?? '';
    final String seasonalColor = answers['seasonal_color'] ?? '';

    // Logika penentuan hasil berdasarkan jawaban
    if (undertone == 'warm') {
      if (seasonalColor == 'bright_warm') {
        return 'Warm Spring';
      } else {
        return 'Warm Autumn';
      }
    } else if (undertone == 'cool') {
      if (seasonalColor == 'soft_cool') {
        return 'Cool Summer';
      } else {
        return 'Cool Winter';
      }
    }

    // Fallback jika ada jawaban yang tidak terduga
    return 'Neutral';
  }
}

