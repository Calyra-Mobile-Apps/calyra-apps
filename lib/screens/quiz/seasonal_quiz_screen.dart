// Lokasi file: lib/screens/quiz/seasonal_color_quiz_screen.dart

import 'dart:typed_data';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeasonalColorQuizScreen extends StatelessWidget {
  const SeasonalColorQuizScreen({super.key});

  // --- Palet Warna untuk Warm Tone ---
  static const warmPalettes = {
    'bright_warm': [Color(0xfff3a683), Color(0xfff7d794), Color(0xff77dd77), Color(0xfff8a5c2)],
    'earthy_warm': [Color(0xffcc8e77), Color(0xffe1b382), Color(0xff7a8e7a), Color(0xffc23616)],
  };

  // --- Palet Warna untuk Cool Tone ---
  static const coolPalettes = {
    'soft_cool': [Color(0xffd1ccc0), Color(0xffa2b5cd), Color(0xff536878), Color(0xffcfb87c)],
    'vivid_cool': [Color(0xffe74c3c), Color(0xff3498db), Color(0xfff1c40f), Color(0xffffffff)],
  };

  void _onOptionSelected(BuildContext context, String answer) {
    final quizProvider = context.read<QuizProvider>();
    // 1. Simpan jawaban terakhir
    quizProvider.addAnswer('seasonal_color', answer);

    // 2. Navigasi ke halaman hasil (kita akan buat ini selanjutnya)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuizResultScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final Uint8List? selfieBytes = quizProvider.selfieImageBytes;
    final String undertone = quizProvider.answers['undertone'] ?? 'warm'; // Default ke 'warm' jika tidak ada

    // Tentukan palet mana yang akan ditampilkan berdasarkan jawaban undertone
    final palettesToShow = undertone == 'warm' ? warmPalettes : coolPalettes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seasonal Color'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              if (selfieBytes != null)
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: MemoryImage(selfieBytes),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const Text(
                "Which color palette looks best on you?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Tampilkan palet berdasarkan undertone
              ...palettesToShow.entries.map((entry) {
                return _buildPaletteOption(
                  context: context,
                  palettes: entry.value,
                  onTap: () => _onOptionSelected(context, entry.key),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaletteOption({required BuildContext context, required List<Color> palettes, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: palettes.map((color) {
              return Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

