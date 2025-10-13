// Lokasi file: lib/providers/quiz_provider.dart

import 'dart:typed_data'; // Digunakan untuk Uint8List
import 'package:flutter/foundation.dart'; // Digunakan untuk kIsWeb dan ChangeNotifier

// Provider ini bertugas menyimpan data kuis sementara (foto & jawaban)
class QuizProvider with ChangeNotifier {
  // Ubah dari File? menjadi Uint8List? agar kompatibel dengan web
  Uint8List? _selfieImageBytes;
  final Map<String, String> _answers = {};

  Uint8List? get selfieImageBytes => _selfieImageBytes;
  Map<String, String> get answers => _answers;

  // Menyimpan foto selfie yang diambil dalam bentuk bytes
  void setSelfieBytes(Uint8List imageBytes) {
    _selfieImageBytes = imageBytes;
    notifyListeners();
  }

  // Menambah jawaban dari setiap langkah kuis
  void addAnswer(String questionId, String answer) {
    _answers[questionId] = answer;
    notifyListeners();
  }

  // Membersihkan data setelah kuis selesai
  void resetQuiz() {
    _selfieImageBytes = null;
    _answers.clear();
    notifyListeners();
  }
}

