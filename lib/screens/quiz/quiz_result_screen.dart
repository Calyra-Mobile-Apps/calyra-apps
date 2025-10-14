// Lokasi file: lib/screens/quiz/quiz_result_screen.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/main_screen.dart';
import 'package:calyra/services/analysis_service.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizResultScreen extends StatefulWidget {
  // Jika halaman ini dibuka dari riwayat, ia akan menerima data hasil.
  // Jika dibuka setelah kuis, 'resultFromHistory' akan null.
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
    // Cek apakah halaman ini dibuka dari riwayat atau dari alur kuis
    if (widget.resultFromHistory != null) {
      // Jika dari riwayat, langsung tampilkan hasilnya tanpa proses
      setState(() {
        _analysisResult = widget.resultFromHistory;
        _isLoading = false;
      });
    } else {
      // Jika dari alur kuis, jalankan proses analisis
      // Menggunakan addPostFrameCallback untuk memastikan context sudah siap
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processAndSaveResult();
      });
    }
  }

  /// Fungsi ini hanya dijalankan jika halaman diakses dari alur kuis.
  Future<void> _processAndSaveResult() async {
    if (!mounted) return;

    // 1. Ambil semua dependensi yang dibutuhkan
    final quizProvider = context.read<QuizProvider>();
    final analysisService = AnalysisService();
    final firestoreService = FirestoreService();

    // 2. Dapatkan hasil analisis menggunakan sesi kuis
    final AnalysisResult result =
        analysisService.analyze(quizProvider.session);

    // 3. Simpan hasil ke Firestore untuk riwayat
    final saveResponse = await firestoreService.saveAnalysisResult(result);

    if (!mounted) return;

    if (!saveResponse.isSuccess && saveResponse.message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(saveResponse.message!)));
    }

    // 4. Perbarui state UI untuk menampilkan hasil
    setState(() {
      _analysisResult = result;
      _isLoading = false;
    });

    // 5. Bersihkan data kuis sementara (foto & jawaban) dari memori
    quizProvider.resetQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Jika dibuka dari riwayat, tombol kembali akan muncul otomatis.
        // Jika dari kuis, tampilkan tombol close.
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

  // Widget untuk membangun konten utama halaman hasil
  Widget _buildResultContent() {
    if (_analysisResult == null) {
      return const Center(child: Text('Failed to get analysis result.'));
    }

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
            _analysisResult!.seasonResult,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'As a Warm Autumn, your natural radiance comes alive in rich, warm, and earthy colors.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Color Palettes'),
          const SizedBox(height: 16),
          _buildColorPalettes(),
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

  // --- Widget-widget helper ---

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

  Widget _buildColorPalettes() {
    // Placeholder - Nanti ini bisa dibuat dinamis berdasarkan _analysisResult
    final List<Color> colors = [
      const Color(0xff4a633a), const Color(0xffd58c58), const Color(0xffb76a71), const Color(0xff9f3b34),
      const Color(0xff3f7175), const Color(0xff5a9a9f), const Color(0xff685f81), const Color(0xff5f5434),
      const Color(0xffe1d9c3), const Color(0xffe3d091), const Color(0xff4a3a3a), const Color(0xff2d405d),
    ];

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
    // Placeholder
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.8,
      children: [
        _buildBrandCard(context, brandName: 'Wardah', imageUrl: 'https://placehold.co/300x400/EBD4CB/000000?text=Wardah'),
        _buildBrandCard(context, brandName: 'Emina', imageUrl: 'https://placehold.co/300x400/F5D7E5/000000?text=Emina'),
      ],
    );
  }

  Widget _buildBrandCard(BuildContext context, {required String brandName, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigasi ke halaman katalog brand
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.error)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                brandName,
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

