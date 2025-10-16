// lib/screens/quiz/skintone_quiz_screen.dart

import 'dart:typed_data';
import 'package:calyra/models/quiz/quiz_keys.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/quiz/seasonal_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- DATA BARU: Memetakan setiap warna ke skintone_group_id ---
class SkintoneOption {
  final Color color;
  final int groupId;

  const SkintoneOption({required this.color, required this.groupId});
}

final List<SkintoneOption> skintoneOptions = List.generate(20, (index) {
  // Warna-warna ini sama seperti sebelumnya
  final colors = [
    const Color(0xFFF1EAE1), const Color(0xFFEADCCF), const Color(0xFFE3CBB8), const Color(0xFFD6B9A1),
    const Color(0xFFC6A68A), const Color(0xFFB59273), const Color(0xFFA88365), const Color(0xFF9B7658),
    const Color(0xFF8C684C), const Color(0xFF7D5B41), const Color(0xFF6E4E36), const Color(0xFF5F412B),
    const Color(0xFFFDE9E4), const Color(0xFFE8C7A7), const Color(0xFFC6A98F), const Color(0xFF9E7C69),
    const Color(0xFFF7F2EF), const Color(0xFFEFE2DD), const Color(0xFFC7B1A4), const Color(0xFF9E8981),
  ];
  return SkintoneOption(color: colors[index], groupId: index + 1);
});
// -----------------------------------------------------------------

class SkintoneQuizScreen extends StatefulWidget {
  const SkintoneQuizScreen({super.key});

  @override
  State<SkintoneQuizScreen> createState() => _SkintoneQuizScreenState();
}

class _SkintoneQuizScreenState extends State<SkintoneQuizScreen> {
  SkintoneOption? _selectedOption;

  void _onOptionSelected(SkintoneOption option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _onNextPressed(BuildContext context) {
    if (_selectedOption == null) return;
    
    // Simpan groupId sebagai string ke provider
    context.read<QuizProvider>().addAnswer(QuizKeys.skintone, _selectedOption!.groupId.toString());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeasonalColorQuizScreen()),
    );
  }

  Color _getBackgroundColor() {
    return _selectedOption?.color ?? skintoneOptions.first.color;
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? selfieBytes = context.watch<QuizProvider>().selfieImageBytes;
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
                        final option = skintoneOptions[index];
                        final isSelected = option.groupId == _selectedOption?.groupId;
        
                        return GestureDetector(
                          onTap: () => _onOptionSelected(option),
                          child: Container(
                            decoration: BoxDecoration(
                              color: option.color,
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
                onPressed: _selectedOption == null ? null : () => _onNextPressed(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedOption != null ? Colors.black : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedOption != null ? Colors.white : Colors.grey[600],
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
