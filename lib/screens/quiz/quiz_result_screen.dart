// Lokasi file: lib/screens/quiz/quiz_result_screen.dart

import 'package:calyra/data/brand_data.dart';
import 'package:calyra/data/season_data.dart';
import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/brand_info.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/main_screen.dart';
import 'package:calyra/screens/quiz/recommendations_screen.dart';
import 'package:calyra/services/analysis_service.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:calyra/widgets/brand_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    final AnalysisResult result = analysisService.analyze(quizProvider.session);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: widget.resultFromHistory != null,
        actions: widget.resultFromHistory == null
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainScreen()),
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

    final String fullSeasonName = _analysisResult!.seasonResult;
    final seasonData =
        seasonDetails[fullSeasonName] ?? seasonDetails['Neutral']!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'You Are a',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
                Text(
                  fullSeasonName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  seasonData.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black54, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildSectionTitle('Color Palettes'),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildColorPalettes(seasonData.colors),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildSectionTitle('Your Product Recommendations'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Explore your recommended products from the following brands:',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 24),
                _buildBrandRecommendations(context),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(1),
          bottomLeft: Radius.circular(1),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
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
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: colors[index],
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildBrandRecommendations(BuildContext context) {
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
        return BrandCard(
          brandName: brand.name,
          imageUrl: brand.imageUrl,
          logoPath: brand.homeLogoPath ?? brand.logoPath,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RecommendationsScreen(
                  brandName: brand.name,
                  analysisResult: _analysisResult!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
