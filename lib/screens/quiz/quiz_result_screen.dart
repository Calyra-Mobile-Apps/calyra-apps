// lib/screens/quiz/quiz_result_screen.dart

import 'package:calyra/data/brand_data.dart';
import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/brand_info.dart';
import 'package:calyra/models/season_filter.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/brand/brand_catalog_screen.dart';
import 'package:calyra/screens/main_screen.dart';
import 'package:calyra/services/analysis_service.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recommendations_screen.dart';

// --- DATA PALET WARNA UNTUK SEMUA MUSIM ---
const Map<String, List<Color>> seasonPalettes = {
  'Warm Autumn': [
    Color(0xff4a633a), Color(0xffd58c58), Color(0xffb76a71), Color(0xff9f3b34),
    Color(0xff3f7175), Color(0xff5a9a9f), Color(0xff685f81), Color(0xff5f5434),
    Color(0xffe1d9c3), Color(0xffe3d091), Color(0xff4a3a3a), Color(0xff2d405d),
  ],
  'Warm Spring': [
    Color(0xFFFCF3BA), Color(0xFFEBCAA4), Color(0xFFFDE470), Color(0xFF926F45),
    Color(0xFFFAB357), Color(0xFFFD9675), Color(0xFFAFEDBE), Color(0xFF92D472),
    Color(0xFFF8A9A5), Color(0xFFE85F79), Color(0xFFFE99AB), Color(0xFFFCD4D5),
  ],
  'Cool Winter': [
    Color(0xFFF5F5F5), Color(0xFFA1A0A5), Color(0xFF655555), Color(0xFF000000),
    Color(0xFF01219C), Color(0xFF07C3FC), Color(0xFF2573E2), Color(0xFF704FDE),
    Color(0xFF71FFD9), Color(0xFFA41C4E), Color(0xFFD72A55), Color(0xFFC4288D),
  ],
  'Cool Summer': [
    Color(0xFFFFFFFF), Color(0xFFB6B5BB), Color(0xFF9E8686), Color(0xFF000000),
    Color(0xFF6583C9), Color(0xFF62CDED), Color(0xFF6193DD), Color(0xFFAA97E6),
    Color(0xFF71E7C7), Color(0xFFBE4A75), Color(0xFFE769A8), Color(0xFFC761A3),
  ],
  'Unknown': [ // Fallback
    Colors.grey, Colors.grey, Colors.grey, Colors.grey,
    Colors.grey, Colors.grey, Colors.grey, Colors.grey,
    Colors.grey, Colors.grey, Colors.grey, Colors.grey,
  ],
};
// ---------------------------------------------

class QuizResultScreen extends StatefulWidget {
  final AnalysisResult? resultFromHistory;

  const QuizResultScreen({super.key, this.resultFromHistory});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  AnalysisResult? _analysisResult;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.resultFromHistory != null) {
      setState(() {
        _analysisResult = widget.resultFromHistory;
        _isLoading = false;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processAndSaveResult();
      });
    }
  }

  Future<void> _processAndSaveResult() async {
    if (!mounted) return;
    final quizProvider = context.read<QuizProvider>();
    final analysisService = AnalysisService();
    final firestoreService = FirestoreService();
    final AnalysisResult result =
        analysisService.analyze(quizProvider.session);
    final saveResponse = await firestoreService.saveAnalysisResult(result);
    if (!mounted) return;
    if (!saveResponse.isSuccess && saveResponse.message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(saveResponse.message!)));
    }
    setState(() {
      _analysisResult = result;
      _isLoading = false;
    });
    quizProvider.resetQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.resultFromHistory != null,
        actions: widget.resultFromHistory == null
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                      (route) => false,
                    );
                  },
                )
              ]
            : [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildResultContent(),
    );
  }

  Widget _buildResultContent() {
    if (_analysisResult == null) {
      return const Center(child: Text('Failed to get analysis result.'));
    }

    final String seasonResult = _analysisResult!.seasonResult;
    final List<Color> currentPalette = seasonPalettes[seasonResult] ?? seasonPalettes['Unknown']!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'You Are a',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
          Text(
            seasonResult,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _getSeasonDescription(seasonResult), // Deskripsi dinamis
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Color Palettes'),
          const SizedBox(height: 16),
          _buildColorPalettes(currentPalette), // Kirim palet warna yang sesuai
          const SizedBox(height: 30),
          _buildSectionTitle('Your Product Recommendations'),
          const SizedBox(height: 8),
          const Text(
            'Explore your recommended products from the following brands:',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildBrandRecommendations(context),
        ],
      ),
    );
  }

  String _getSeasonDescription(String season) {
    switch (season) {
      case 'Warm Autumn':
        return 'As a Warm Autumn, your natural radiance comes alive in rich, warm, and earthy colors.';
      case 'Warm Spring':
        return 'As a Warm Spring, you shine in bright, clear, and warm colors that reflect the vibrancy of spring.';
      case 'Cool Winter':
        return 'As a Cool Winter, your look is stunning in bold, cool, and high-contrast colors.';
      case 'Cool Summer':
        return 'As a Cool Summer, you look best in soft, muted, and cool-toned colors.';
      default:
        return 'Discover the colors that best suit your unique palette.';
    }
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildColorPalettes(List<Color> colors) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: colors.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: colors[index],
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  Widget _buildBrandRecommendations(BuildContext context) {
    // Menggunakan data brand dari `featuredBrands` yang diimpor
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: featuredBrands.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final brand = featuredBrands[index];
        // Logika sederhana untuk memilih path gambar
        String assetPath;
        if (brand.name.toLowerCase() == 'wardah') {
          assetPath = 'assets/images/wardah-result.png';
        } else if (brand.name.toLowerCase() == 'emina') {
          assetPath = 'assets/images/emina-result.png';
        } else {
          assetPath = brand.imageUrl; // Fallback ke gambar utama
        }

        return _buildBrandCard(context, brand: brand, assetPath: assetPath);
      },
    );
  }

  Widget _buildBrandCard(BuildContext context, {required BrandInfo brand, required String assetPath}) {
    return GestureDetector(
      onTap: () {
        final String seasonResult = _analysisResult!.seasonResult;
        
        // Navigasi ke RecommendationsScreen yang baru
        // Mengirim nama brand dan nama season lengkap
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecommendationsScreen(
              brandName: brand.name,
              seasonName: seasonResult, 
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.error)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                brand.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}