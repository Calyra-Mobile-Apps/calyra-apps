import 'dart:typed_data';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeasonalColorQuizScreen extends StatefulWidget {
  const SeasonalColorQuizScreen({super.key});

  @override
  State<SeasonalColorQuizScreen> createState() => _SeasonalColorQuizScreenState();
}

class _SeasonalColorQuizScreenState extends State<SeasonalColorQuizScreen> {
  Color? _selectedColor; // warna yang dipilih user

  // --- Daftar semua warna seasonal (contoh: 8 kotak) ---
  static const List<Color> seasonalColors = [
    Color(0xfff3a683),
    Color(0xfff7d794),
    Color(0xff77dd77),
    Color(0xfff8a5c2),
    Color(0xffcc8e77),
    Color(0xffe1b382),
    Color(0xff7a8e7a),
    Color(0xffc23616),
  ];

  void _onColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _onNextPressed(BuildContext context) {
    if (_selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih salah satu warna terlebih dahulu!')),
      );
      return;
    }

    // Simpan jawaban ke provider sebagai hex string
    context.read<QuizProvider>().addAnswer(
          QuizKeys.seasonalColor,
          '#${_selectedColor!.value.toRadixString(16).substring(2).toUpperCase()}',
        );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuizResultScreen()),
    );
  }

  // Helper untuk mendapatkan background color
  Color _getBackgroundColor() {
    if (_selectedColor == null) {
      return seasonalColors.first; // Default warna pertama
    }
    return _selectedColor!;
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? selfieBytes = context.watch<QuizProvider>().selfieImageBytes;
    final Color backgroundColor = _getBackgroundColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seasonal Color'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // --- Area Selfie & Background Warna (STRUKTUR BARU) ---
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 300,
                        height: 350,
                        decoration: BoxDecoration(
                          color: backgroundColor, // Background dari warna terpilih
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: _buildSelfieArea(selfieBytes),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Choose your seasonal color",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),

                    // Frame besar yang menampung kotak warna
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: seasonalColors.length,
                        itemBuilder: (context, index) {
                          final color = seasonalColors[index];
                          final isSelected = _selectedColor == color;

                          return GestureDetector(
                            onTap: () => _onColorSelected(color),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? Colors.black : Colors.transparent,
                                  width: 3,
                                ),
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

            // --- Tombol Next di Bawah ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _selectedColor == null ? null : () => _onNextPressed(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColor != null ? Colors.black : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _selectedColor != null ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk area selfie (SAMA DENGAN SKINTONE)
  Widget _buildSelfieArea(Uint8List? selfieBytes) {
    Widget imageWidget = selfieBytes != null
        ? Image.memory(selfieBytes, fit: BoxFit.cover)
        : Center(
            child: Text('Selfie not found',
                style: TextStyle(color: Colors.grey[600])),
          );

    return Container(
      width: 220,
      height: 220,
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
}