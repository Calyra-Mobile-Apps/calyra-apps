// Lokasi file: lib/services/analysis_service.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/models/quiz_session.dart';

class AnalysisService {
  AnalysisResult analyze(QuizSession session, {DateTime? analysisDate}) {
    final answers = session.answers;
    final undertone = answers[QuizKeys.undertone] ?? 'neutral';
    final skintone = answers[QuizKeys.skintone] ?? '0';
    final seasonalChoice = answers[QuizKeys.seasonalColor] ?? 'unknown';
    final String finalSeasonResult = _resolveSeason(undertone, seasonalChoice);

    return AnalysisResult(
      seasonResult: finalSeasonResult,
      undertone: undertone,
      skintone: skintone,
      analysisDate: analysisDate ?? DateTime.now(),
    );
  }

  String _resolveSeason(String undertone, String seasonalChoice) {
    if (seasonalChoice == 'unknown' || seasonalChoice.isEmpty) {
      if (undertone == 'warm') return 'Warm Autumn'; // Default untuk warm
      if (undertone == 'cool') return 'Cool Winter'; // Default untuk cool
      return 'Neutral';
    }

    if (undertone == 'warm') {
      if (seasonalChoice == 'Spring') {
        return 'Warm Spring';
      } else if (seasonalChoice == 'Autumn') {
        return 'Warm Autumn';
      }
    }

    if (undertone == 'cool') {
      if (seasonalChoice == 'Summer') {
        return 'Cool Summer';
      } else if (seasonalChoice == 'Winter') {
        return 'Cool Winter';
      }
    }
    return 'Neutral';
  }
}
