// Lokasi file: lib/services/analysis_service.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/models/quiz_session.dart';

class AnalysisService {
  AnalysisResult analyze(QuizSession session, {DateTime? analysisDate}) {
    final answers = session.answers;
    final undertone = answers[QuizKeys.undertone] ?? 'neutral';
    final skintone = answers[QuizKeys.skintone] ?? 'unknown';
    final seasonalColor = answers[QuizKeys.seasonalColor] ?? 'unknown';
    final seasonResult = _resolveSeason(undertone, seasonalColor);

    return AnalysisResult(
      seasonResult: seasonResult,
      undertone: undertone,
      skintone: skintone,
      analysisDate: analysisDate ?? DateTime.now(),
    );
  }

  String _resolveSeason(String undertone, String seasonalResult) {
    if (seasonalResult == 'unknown' || seasonalResult.isEmpty) {
      if (undertone == 'warm') return 'Warm Autumn';
      if (undertone == 'cool') return 'Cool Winter';
      return 'Neutral';
    }

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

    return seasonalResult;
  }
}
