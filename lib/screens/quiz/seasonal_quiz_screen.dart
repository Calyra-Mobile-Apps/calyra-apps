// lib/screens/quiz/seasonal_quiz_screen.dart

import 'dart:typed_data';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/quiz/quiz_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- DATA PALET WARNA (4 WARNA PER MUSIM) ---
const List<Map<String, List<Color>>> warmStepPalettes = [
  // Screen 1
  {
    'Spring': [Color(0xFFFCF3BA), Color(0xFFEBCAA4), Color(0xFFFDE470), Color(0xFF926F45)],
    'Autumn': [Color(0xFFF4EED4), Color(0xFFDDBF99), Color(0xFFE8D167), Color(0xFF66371B)],
  },
  // Screen 2
  {
    'Spring': [Color(0xFFFAB357), Color(0xFFFD9675), Color(0xFFAFEDBE), Color(0xFF92D472)],
    'Autumn': [Color(0xFFE5A453), Color(0xFFE18E30), Color(0xFFB47331), Color(0xFF6EAC83)],
  },
  // Screen 3
  {
    'Spring': [Color(0xFFF8A9A5), Color(0xFFE85F79), Color(0xFFFE99AB), Color(0xFFFCD4D5)],
    'Autumn': [Color(0xFFBD2E20), Color(0xFFB14A5D), Color(0xFFF48598), Color(0xFFDD9598)],
  },
];

const List<Map<String, List<Color>>> coolStepPalettes = [
  // Screen 1
  {
    'Summer': [Color(0xFFFFFFFF), Color(0xFFB6B5BB), Color(0xFF9E8686), Color(0xFF000000)],
    'Winter': [Color(0xFFF5F5F5), Color(0xFFA1A0A5), Color(0xFF655555), Color(0xFF000000)],
  },
  // Screen 2
  {
    'Summer': [Color(0xFF6583C9), Color(0xFF62CDED), Color(0xFF6193DD), Color(0xFFAA97E6)],
    'Winter': [Color(0xFF01219C), Color(0xFF07C3FC), Color(0xFF2573E2), Color(0xFF704FDE)],
  },
  // Screen 3
  {
    'Summer': [Color(0xFF71E7C7), Color(0xFFBE4A75), Color(0xFFE769A8), Color(0xFFC761A3)],
    'Winter': [Color(0xFF71FFD9), Color(0xFFA41C4E), Color(0xFFD72A55), Color(0xFFC4288D)],
  },
];


class SeasonalColorQuizScreen extends StatefulWidget {
  const SeasonalColorQuizScreen({super.key});

  @override
  State<SeasonalColorQuizScreen> createState() => _SeasonalColorQuizScreenState();
}

class _SeasonalColorQuizScreenState extends State<SeasonalColorQuizScreen> {
  int _currentStep = 0;
  Color? _activeSelfieBackgroundColor;
  String? _selectedSeasonForRow;
  int _season1Score = 0;
  int _season2Score = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_activeSelfieBackgroundColor == null) {
      _initializeBackgroundColor();
    }
  }

  void _initializeBackgroundColor() {
    final undertone = context.read<QuizProvider>().answers[QuizKeys.undertone];
    final isWarm = undertone == 'warm';
    final palettes = isWarm ? warmStepPalettes : coolStepPalettes;
    final season1Name = isWarm ? 'Spring' : 'Summer';
    if (_currentStep < palettes.length && palettes[_currentStep].containsKey(season1Name)) {
      setState(() {
        _activeSelfieBackgroundColor = palettes[_currentStep][season1Name]![0];
      });
    }
  }

  void _onNextPressed() {
    if (_selectedSeasonForRow == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih salah satu baris palet terlebih dahulu')),
      );
      return;
    }

    final isWarm = context.read<QuizProvider>().answers[QuizKeys.undertone] == 'warm';
    final season1Name = isWarm ? 'Spring' : 'Summer';

    if (_selectedSeasonForRow == season1Name) {
      _season1Score++;
    } else {
      _season2Score++;
    }

    final totalSteps = isWarm ? warmStepPalettes.length : coolStepPalettes.length;

    if (_currentStep < totalSteps - 1) {
      setState(() {
        _currentStep++;
        _selectedSeasonForRow = null;
        final palettes = isWarm ? warmStepPalettes : coolStepPalettes;
        final nextSeason1Name = isWarm ? 'Spring' : 'Summer';
        _activeSelfieBackgroundColor = palettes[_currentStep][nextSeason1Name]![0];
      });
    } else {
      _finalizeAndNavigate();
    }
  }

  void _finalizeAndNavigate() {
    final undertone = context.read<QuizProvider>().answers[QuizKeys.undertone];
    String finalSeason;
    if (undertone == 'warm') {
      finalSeason = _season1Score > _season2Score ? 'Spring' : 'Autumn';
    } else {
      finalSeason = _season1Score > _season2Score ? 'Summer' : 'Winter';
    }
    context.read<QuizProvider>().addAnswer(QuizKeys.seasonalColor, finalSeason);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const QuizResultScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final Uint8List? selfieBytes = quizProvider.selfieImageBytes;
    final isWarm = quizProvider.answers[QuizKeys.undertone] == 'warm';

    final palettes = isWarm ? warmStepPalettes : coolStepPalettes;
    if (_currentStep >= palettes.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final currentPalettes = palettes[_currentStep];
    
    final season1Name = isWarm ? 'Spring' : 'Summer';
    final season2Name = isWarm ? 'Autumn' : 'Winter';
    
    final season1Colors = currentPalettes[season1Name]!;
    final season2Colors = currentPalettes[season2Name]!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Seasonal Color'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 300,
                height: 300, 
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // DISAMAKAN: 20
                  color: _activeSelfieBackgroundColor,
                ),
                child: Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: selfieBytes != null
                          ? DecorationImage(image: MemoryImage(selfieBytes), fit: BoxFit.cover)
                          : null,
                      color: selfieBytes == null ? Colors.grey[200] : null,
                    ),
                  ),
                ),
              ),
              const Text(
                'Try each color, then choose the palette row that suits you best.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              _ColorPaletteRow(
                colors: season1Colors,
                isSelected: _selectedSeasonForRow == season1Name,
                activeColor: _activeSelfieBackgroundColor,
                onColorTap: (color) => setState(() => _activeSelfieBackgroundColor = color),
                onSelect: () => setState(() => _selectedSeasonForRow = season1Name),
              ),
              const SizedBox(height: 24),
              _ColorPaletteRow(
                colors: season2Colors,
                isSelected: _selectedSeasonForRow == season2Name,
                activeColor: _activeSelfieBackgroundColor,
                onColorTap: (color) => setState(() => _activeSelfieBackgroundColor = color),
                onSelect: () => setState(() => _selectedSeasonForRow = season2Name),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSeasonForRow != null ? Colors.black : Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentStep < palettes.length - 1 ? 'Next' : 'Finish',
                    style: TextStyle(
                      fontSize: 18,
                      color: _selectedSeasonForRow != null ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPaletteRow extends StatelessWidget {
  final List<Color> colors;
  final bool isSelected;
  final Color? activeColor;
  final ValueChanged<Color> onColorTap;
  final VoidCallback onSelect;

  const _ColorPaletteRow({
    required this.colors,
    required this.isSelected,
    required this.activeColor,
    required this.onColorTap,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: colors.map((color) {
            final bool isColorActive = activeColor == color;
            return GestureDetector(
              onTap: () => onColorTap(color),
              child: Container(
                width: 45,
                height: 65,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isColorActive ? Colors.grey.shade700 : Colors.grey.shade300,
                    width: isColorActive ? 3.0 : 0.5,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}