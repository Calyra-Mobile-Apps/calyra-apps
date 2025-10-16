// Lokasi file: lib/screens/quiz/skintone_quiz_screen.dart

import 'dart:typed_data';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/quiz/seasonal_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SkintoneQuizScreen extends StatefulWidget {
  const SkintoneQuizScreen({super.key});

  @override
  State<SkintoneQuizScreen> createState() => _SkintoneQuizScreenState();
}

class _SkintoneQuizScreenState extends State<SkintoneQuizScreen> {
  String? _selectedAnswer; // Menyimpan warna yang dipilih
  Color _backgroundColor = Colors.white; // Background awal

  // List warna skintone (hex)
  final List<Map<String, dynamic>> skintoneOptions = [
    {'hex': const Color(0xFFF1EAE1), 'value': 'F1EAE1'},
    {'hex': const Color(0xFFEADCCF), 'value': 'EADCCF'},
    {'hex': const Color(0xFFE3CBB8), 'value': 'E3CBB8'},
    {'hex': const Color(0xFFD6B9A1), 'value': 'D6B9A1'},
    {'hex': const Color(0xFFC6A68A), 'value': 'C6A68A'},
    {'hex': const Color(0xFFB59273), 'value': 'B59273'},
    {'hex': const Color(0xFFA88365), 'value': 'A88365'},
    {'hex': const Color(0xFF9B7658), 'value': '9B7658'},
    {'hex': const Color(0xFF8C684C), 'value': '8C684C'},
    {'hex': const Color(0xFF7D5B41), 'value': '7D5B41'},
    {'hex': const Color(0xFF6E4E36), 'value': '6E4E36'},
    {'hex': const Color(0xFF5F412B), 'value': '5F412B'},
  ];

  void _onOptionSelected(String value, Color bgColor) {
    setState(() {
      _selectedAnswer = value;
      _backgroundColor = bgColor; // ubah background sesuai warna yang dipilih
    });
  }

  void _onNextPressed(BuildContext context) {
    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih salah satu warna terlebih dahulu!')),
      );
      return;
    }

    // Simpan jawaban ke provider
    context.read<QuizProvider>().addAnswer(QuizKeys.skintone, _selectedAnswer!);

    // Lanjut ke halaman quiz berikutnya
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeasonalColorQuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? selfieBytes = context.watch<QuizProvider>().selfieImageBytes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Tone'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: _backgroundColor, // ← background mengikuti kotak yang dipilih
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Foto selfie
              if (selfieBytes != null)
                Container(
                  width: 220,
                  height: 220,
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: MemoryImage(selfieBytes),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                )
              else
                Container(
                  width: 220,
                  height: 220,
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  alignment: Alignment.center,
                  child: const Text('Selfie not found', style: TextStyle(color: Colors.grey)),
                ),

              const Text(
                "Choose your skin tone",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              // Frame besar menampung semua kotak warna
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: skintoneOptions.length,
                    itemBuilder: (context, index) {
                      final option = skintoneOptions[index];
                      final bool isSelected = _selectedAnswer == option['value'];
                      return GestureDetector(
                        onTap: () => _onOptionSelected(option['value'], option['hex']),
                        child: Container(
                          decoration: BoxDecoration(
                            color: option['hex'],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tombol Next
              ElevatedButton(
                onPressed: () => _onNextPressed(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
