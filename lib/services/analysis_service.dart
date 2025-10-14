// Lokasi file: lib/services/analysis_service.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/models/quiz_session.dart';

class AnalysisService {
  AnalysisResult analyze(QuizSession session, {DateTime? analysisDate}) {
    final answers = session.answers;
    final undertone = answers[QuizKeys.undertone] ?? 'neutral';
    final skintone = answers[QuizKeys.skintone] ?? 'unknown';
    final seasonalColor = answers[QuizKeys.seasonalColor] ?? '';

    final seasonResult = _resolveSeason(undertone, seasonalColor);

    return AnalysisResult(
      seasonResult: seasonResult,
      undertone: undertone,
      skintone: skintone,
      analysisDate: analysisDate ?? DateTime.now(),
    );
  }

  String _resolveSeason(String undertone, String seasonalColor) {
    if (undertone == 'warm') {
      return seasonalColor == 'bright_warm' ? 'Warm Spring' : 'Warm Autumn';
    }

    if (undertone == 'cool') {
      return seasonalColor == 'soft_cool' ? 'Cool Summer' : 'Cool Winter';
    }

    return 'Neutral';
  }
}

