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
  // Daftar warna skintone untuk ditampilkan (16 pilihan)
  static const List<Color> skintoneOptions = [
    // Baris 1: Paling terang ke sedang
    Color(0xFFF1EAE1), Color(0xFFEADCCF), Color(0xFFE3CBB8), Color(0xFFD6B9A1),
    Color(0xFFC6A68A), Color(0xFFB59273), Color(0xFFA88365), Color(0xFF9B7658),
    // Baris 2: Sedang ke gelap
    Color(0xFF8C684C), Color(0xFF7D5B41), Color(0xFF6E4E36), Color(0xFF5F412B),
    // BARU: Tambahkan baris 3 & 4 (atau sesuaikan 12 menjadi 16)
    Color(0xFFFDE9E4), Color(0xFFE8C7A7), Color(0xFFC6A98F), Color(0xFF9E7C69),
    Color(0xFFF7F2EF), Color(0xFFEFE2DD), Color(0xFFC7B1A4), Color(0xFF9E8981),
  ];

  // State untuk melacak pilihan pengguna
  String? _selectedColorHex; // Menyimpan hex (String) dari warna yang dipilih

  void _onOptionSelected(Color color) {
    setState(() {
      // Ubah warna menjadi hex string untuk disimpan sebagai jawaban
      _selectedColorHex =
          color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
      // Set the color for the background box to be instantly visible
    });
  }

  void _onNextPressed(BuildContext context) {
    if (_selectedColorHex == null) return;

    // 1. Simpan jawaban ke provider
    // Ambil hanya 6 digit (RGB) untuk skintone, buang 2 digit pertama (Alpha)
    final answer = _selectedColorHex!.substring(2);
    context.read<QuizProvider>().addAnswer(QuizKeys.skintone, answer);

    // 2. Navigasi ke halaman kuis berikutnya
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeasonalColorQuizScreen()),
    );
  }

  Color _getBackgroundColor() {
    if (_selectedColorHex == null) {
      return Color(skintoneOptions.first.value).withOpacity(1);
    }
    return Color(int.parse(_selectedColorHex!, radix: 16)).withOpacity(1);
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? selfieBytes =
        context.watch<QuizProvider>().selfieImageBytes;
    final Color backgroundColor = _getBackgroundColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Tone'),
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
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(20),
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
                      "Choose your skin tone",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),

                    // Grid untuk pilihan warna kulit
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: skintoneOptions.length,
                      itemBuilder: (context, index) {
                        final color = skintoneOptions[index];
                        final colorHex = color.value
                            .toRadixString(16)
                            .padLeft(8, '0')
                            .toUpperCase();
                        final isSelected = colorHex == _selectedColorHex;

                        return GestureDetector(
                          onTap: () => _onOptionSelected(color),
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                width: isSelected ? 3.0 : 1.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _selectedColorHex == null
                    ? null
                    : () => _onNextPressed(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColorHex != null
                      ? Colors.black
                      : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedColorHex != null
                          ? Colors.white
                          : Colors.grey[600],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
