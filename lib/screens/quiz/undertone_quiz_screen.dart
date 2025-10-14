// Lokasi file: lib/screens/quiz/undertone_quiz_screen.dart

import 'dart:typed_data';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/quiz/skintone_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UndertoneQuizScreen extends StatelessWidget {
  const UndertoneQuizScreen({super.key});

  // Fungsi untuk menangani saat sebuah opsi dipilih
  void _onOptionSelected(BuildContext context, String answer) {
    // 1. Simpan jawaban ke provider
  context.read<QuizProvider>().addAnswer(QuizKeys.undertone, answer);

    // 2. Navigasi ke halaman kuis berikutnya
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkintoneQuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data gambar dari provider
    final Uint8List? selfieBytes = context.watch<QuizProvider>().selfieImageBytes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Under Tone'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tampilkan gambar selfie jika ada
              if (selfieBytes != null)
                Container(
                  width: 250,
                  height: 250,
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: MemoryImage(selfieBytes),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                )
              else
                // Tampilan jika gambar tidak ditemukan
                Container(
                  width: 250,
                  height: 250,
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Text('Selfie not found', style: TextStyle(color: Colors.grey)),
                  ),
                ),

              // Pilihan Jawaban
              _buildOptionCard(
                context,
                color1: Colors.pink,
                color2: Colors.orange,
                onTap: () => _onOptionSelected(context, 'cool'), // Contoh jawaban
              ),
              const SizedBox(height: 20),
              _buildOptionCard(
                context,
                color1: Colors.grey[300]!,
                color2: Colors.yellow[600]!,
                onTap: () => _onOptionSelected(context, 'warm'), // Contoh jawaban
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat kartu pilihan
  Widget _buildOptionCard(BuildContext context, {required Color color1, required Color color2, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 80, height: 50, color: color1),
              Container(width: 80, height: 50, color: color2),
            ],
          ),
        ),
      ),
    );
  }
}

