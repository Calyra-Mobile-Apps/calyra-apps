import 'dart:typed_data';
import 'dart:collection';

class QuizSession {
  QuizSession({Uint8List? selfieImageBytes})
      : _selfieImageBytes = selfieImageBytes,
        _answers = <String, String>{};

  Uint8List? _selfieImageBytes;
  final Map<String, String> _answers;

  Uint8List? get selfieImageBytes => _selfieImageBytes;
  UnmodifiableMapView<String, String> get answers =>
      UnmodifiableMapView(_answers);

  void setSelfieImage(Uint8List imageBytes) {
    _selfieImageBytes = imageBytes;
  }

  void setAnswer(String questionId, String answer) {
    _answers[questionId] = answer;
  }

  void reset() {
    _selfieImageBytes = null;
    _answers.clear();
  }
}
