// Lokasi file: lib/screens/quiz/undertone_quiz_screen.dart

import 'dart:typed_data';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/quiz/skintone_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- TIPE DATA BARU UNTUK MENDUKUNG WARNA DAN GAMBAR ---
class DecorationInfo {
  final Color? color;
  final String? assetPath;
  final bool isImage;

  const DecorationInfo.solid(Color c)
      : color = c,
        assetPath = null,
        isImage = false;

  const DecorationInfo.image(String path)
      : color = null,
        assetPath = path,
        isImage = true;
}

class QuizStepData {
  final String title;
  final String question;
  final List<ComparisonOption> options;

  const QuizStepData(this.title, this.question, this.options);
}

class ComparisonOption {
  final DecorationInfo decoration;
  final String preference; // 'cool' or 'warm'

  const ComparisonOption(this.decoration, this.preference);
}

// --- DATA KUIS YANG SUDAH DIREVISI ---

final step1 = QuizStepData(
  'Metal/Fabric Comparison',
  'Undertone',
  [
    ComparisonOption(DecorationInfo.solid(Colors.pink.shade500), 'cool'),
    ComparisonOption(DecorationInfo.solid(Colors.deepOrange), 'warm'),
  ],
);

final step2 = QuizStepData(
  'Jewelry Comparison',
  'Undertone',
  [
    // Menggunakan DecorationInfo.image untuk memuat gambar silver.jpg
    ComparisonOption(DecorationInfo.image('assets/images/silver.jpg'), 'cool'),
    // Menggunakan DecorationInfo.image untuk memuat gambar gold.jpg
    ComparisonOption(DecorationInfo.image('assets/images/gold.jpg'), 'warm'),
  ],
);

final step3 = QuizStepData(
  'Shadow/Depth Comparison',
  'Undertone',
  [
    ComparisonOption(DecorationInfo.solid(Colors.brown.shade800), 'warm'),
    ComparisonOption(DecorationInfo.solid(Colors.black), 'cool'),
  ],
);

final List<QuizStepData> quizSteps = [step1, step2, step3];

// --- MAIN SCREEN UNTUK MENGELOLA ALUR KUIS (TIDAK BERUBAH) ---

class UndertoneQuizMainScreen extends StatefulWidget {
  const UndertoneQuizMainScreen({super.key});

  @override
  State<UndertoneQuizMainScreen> createState() =>
      _UndertoneQuizMainScreenState();
}

class _UndertoneQuizMainScreenState extends State<UndertoneQuizMainScreen> {
  int _currentStep = 0;

  void _onNextStep(String preference) {
    final quizProvider = context.read<QuizProvider>();
    quizProvider.recordPreference(preference);

    if (_currentStep < quizSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      final finalUndertone = quizProvider.undertoneScore > 0 ? 'warm' : 'cool';
      quizProvider.addAnswer(QuizKeys.undertone, finalUndertone);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SkintoneQuizScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Judul AppBar 'Under Tone' selalu ditampilkan di tengah
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, 
        title: const Text('Under Tone', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: ColorComparisonStep(
        stepData: quizSteps[_currentStep],
        onNext: _onNextStep,
      ),
    );
  }
}

// --- REUSABLE WIDGET UNTUK SATU LANGKAH PERBANDINGAN WARNA (DIREVISI) ---

class ColorComparisonStep extends StatelessWidget {
  final QuizStepData stepData;
  final Function(String preference) onNext;

  const ColorComparisonStep({
    super.key,
    required this.stepData,
    required this.onNext,
  });

  // Helper untuk mendapatkan BoxDecoration (Color atau Image)
  BoxDecoration _buildDecoration(DecorationInfo info) {
    DecorationImage? image;
    Color? color;

    if (info.isImage && info.assetPath != null) {
      // Jika Image Path tersedia
      image = DecorationImage(
        image: AssetImage(info.assetPath!),
        fit: BoxFit.cover,
      );
    } else if (info.color != null) {
      // Jika Color solid tersedia
      color = info.color;
    } else {
      // Default fallback
      color = Colors.grey[200];
    }

    return BoxDecoration(
      color: color,
      image: image,
      borderRadius: BorderRadius.circular(20), // Default rounded for container
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final Uint8List? selfieBytes = quizProvider.selfieImageBytes;
    final String? selectedSide = quizProvider.currentComparisonSelection;

    // 1. Tentukan DecorationInfo yang dipilih
    DecorationInfo selectedDecorationInfo = DecorationInfo.solid(Colors.white);
    if (selectedSide == 'left') {
      selectedDecorationInfo = stepData.options[0].decoration;
    } else if (selectedSide == 'right') {
      selectedDecorationInfo = stepData.options[1].decoration;
    }

    // 2. Bangun BoxDecoration final untuk container selfie
    BoxDecoration selfieContainerDecoration = _buildDecoration(selectedDecorationInfo).copyWith(
      borderRadius: BorderRadius.circular(20), // Pastikan tetap rounded rectangle
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question
            const SizedBox(height: 24),
            Text(
              stepData.question,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            
            const SizedBox(height: 32),

            // Selfie Display with Animated Square Background
            Center(
              child: LayoutBuilder(builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                final double squareSize = maxWidth < 400 ? maxWidth : 400; 

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: squareSize, 
                  height: squareSize, 
                  decoration: selfieContainerDecoration, 
                  alignment: Alignment.center,
                  child: _buildSelfieImage(selfieBytes, squareSize * 0.75), 
                );
              }),
            ),

            const SizedBox(height: 32),

            // Comparison Options (2 Boxes in a Row)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => quizProvider.setCurrentComparisonSelection('left'),
                    child: _buildOptionBox(
                      stepData.options[0].decoration,
                      selectedSide == 'left',
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => quizProvider.setCurrentComparisonSelection('right'),
                    child: _buildOptionBox(
                      stepData.options[1].decoration,
                      selectedSide == 'right',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Next Button
            ElevatedButton(
              onPressed: selectedSide == null
                  ? null
                  : () {
                      final preference = selectedSide == 'left'
                          ? stepData.options[0].preference
                          : stepData.options[1].preference;
                      onNext(preference);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedSide != null ? Colors.black : Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedSide != null ? Colors.white : Colors.grey[600],
                  )),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan selfie dalam lingkaran
  Widget _buildSelfieImage(Uint8List? selfieBytes, double size) {
    Widget imageWidget = selfieBytes != null
        ? Image.memory(selfieBytes, fit: BoxFit.cover)
        : Center(
            child: Text('Selfie not found',
                style: TextStyle(color: Colors.grey[600])),
          );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipOval(
        child: imageWidget,
      ),
    );
  }

  // Widget untuk menampilkan kotak pilihan warna/metalik di bagian bawah
  Widget _buildOptionBox(
      DecorationInfo info,
      bool isSelected,
  ) {
    final Color borderColor = isSelected ? Colors.black : Colors.transparent;

    BoxDecoration optionDecoration = _buildDecoration(info).copyWith(
      borderRadius: BorderRadius.circular(12), // Kotak bawah sedikit lebih kecil
      border: Border.all(color: borderColor, width: isSelected ? 3 : 1),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 120, // Tinggi tetap untuk kotak opsi
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: optionDecoration,
    );
  }
}