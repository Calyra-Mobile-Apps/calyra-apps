// Lokasi file: lib/screens/quiz/skintone_quiz_screen.dart

import 'dart:typed_data';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/quiz/seasonal_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SkintoneQuizScreen extends StatelessWidget {
  const SkintoneQuizScreen({super.key});

  // Daftar warna skintone untuk ditampilkan
  static const List<Color> skintoneOptions = [
    Color(0xFFF1EAE1), Color(0xFFEADCCF), Color(0xFFE3CBB8), Color(0xFFD6B9A1),
    Color(0xFFC6A68A), Color(0xFFB59273), Color(0xFFA88365), Color(0xFF9B7658),
    Color(0xFF8C684C), Color(0xFF7D5B41), Color(0xFF6E4E36), Color(0xFF5F412B),
  ];

  void _onOptionSelected(BuildContext context, String answer) {
    // 1. Simpan jawaban ke provider
    context.read<QuizProvider>().addAnswer('skintone', answer);

    // 2. Navigasi ke halaman kuis berikutnya
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeasonalColorQuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data gambar dari provider
    final Uint8List? selfieBytes = context.watch<QuizProvider>().selfieImageBytes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Tone'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tampilkan gambar selfie jika ada
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
                )
              else
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: const Center(child: Text('Selfie not found')),
                ),
              
              const Text(
                "Choose your skin tone",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Grid untuk pilihan warna kulit
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: skintoneOptions.length,
                  itemBuilder: (context, index) {
                    final color = skintoneOptions[index];
                    return GestureDetector(
                      onTap: () => _onOptionSelected(context, color.value.toRadixString(16)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300)
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

