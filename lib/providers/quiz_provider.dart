// Lokasi file: lib/providers/quiz_provider.dart

import 'package:calyra/models/quiz_session.dart';
import 'package:flutter/foundation.dart';

class QuizProvider with ChangeNotifier {
  QuizProvider() : _session = QuizSession();

  final QuizSession _session;

  // New state for the interactive quiz: the currently selected color for visual comparison
  // 'left', 'right', or null (for no selection)
  String? _currentComparisonSelection;
  // Score tracker for 3-step undertone logic (Cool preference +1, Warm preference +1)
  int _undertoneScore = 0; // Negative for Cool, Positive for Warm

  QuizSession get session => _session;
  Uint8List? get selfieImageBytes => _session.selfieImageBytes;
  Map<String, String> get answers => Map<String, String>.from(_session.answers);
  
  // New getters
  String? get currentComparisonSelection => _currentComparisonSelection;
  int get undertoneScore => _undertoneScore;

  // New setter for interactive color selection (not a final answer)
  void setCurrentComparisonSelection(String? selection) {
    _currentComparisonSelection = selection;
    notifyListeners();
  }

  // Method to record a preference and advance the step
  void recordPreference(String preferenceType) {
    if (preferenceType == 'cool') {
      _undertoneScore--;
    } else if (preferenceType == 'warm') {
      _undertoneScore++;
    }
    _currentComparisonSelection = null; // Reset selection for next step
    notifyListeners();
  }

  void setSelfieBytes(Uint8List imageBytes) {
    _session.setSelfieImage(imageBytes);
    notifyListeners();
  }

  void addAnswer(String questionId, String answer) {
    _session.setAnswer(questionId, answer);
    notifyListeners();
  }

  void resetQuiz() {
    _session.reset();
    // Resetting quiz should also clear interactive state
    _currentComparisonSelection = null;
    _undertoneScore = 0;
    notifyListeners();
  }
}