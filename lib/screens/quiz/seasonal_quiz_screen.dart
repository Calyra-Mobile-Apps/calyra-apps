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
  Color _backgroundColor = Colors.white; // background mengikuti warna terpilih

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
      _backgroundColor = color;
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

  @override
  Widget build(BuildContext context) {
    final Uint8List? selfieBytes = context.watch<QuizProvider>().selfieImageBytes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seasonal Color'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: _backgroundColor,
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
                  ),
                ),
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
                  shrinkWrap: true, // supaya GridView tidak ambil seluruh height
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
