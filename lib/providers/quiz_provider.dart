// Lokasi file: lib/providers/quiz_provider.dart

import 'package:calyra/models/quiz_session.dart';
import 'package:flutter/foundation.dart';

class QuizProvider with ChangeNotifier {
  QuizProvider() : _session = QuizSession();

  final QuizSession _session;

  QuizSession get session => _session;
  Uint8List? get selfieImageBytes => _session.selfieImageBytes;
  Map<String, String> get answers => Map<String, String>.from(_session.answers);

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
    notifyListeners();
  }
}

