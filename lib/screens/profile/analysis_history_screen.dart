// Lokasi file: lib/screens/profile/analysis_history_screen.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/screens/quiz/quiz_result_screen.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:calyra/widgets/history_card.dart';
import 'package:flutter/material.dart';

class AnalysisHistoryScreen extends StatefulWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  State<AnalysisHistoryScreen> createState() => _AnalysisHistoryScreenState();
}

class _AnalysisHistoryScreenState extends State<AnalysisHistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<AnalysisResult>> _historyFuture;

  // --- MOCK DATA SEMENTARA (Diganti dengan data real dari Firestore) ---
  final List<AnalysisResult> _mockHistory = [
    AnalysisResult(
      seasonResult: 'Cool Summer',
      undertone: 'cool',
      skintone: 'light',
      analysisDate: DateTime(2025, 10, 5),
    ),
    AnalysisResult(
      seasonResult: 'Cool Winter',
      undertone: 'cool',
      skintone: 'fair',
      analysisDate: DateTime(2025, 9, 26),
    ),
    AnalysisResult(
      seasonResult: 'Warm Autumn',
      undertone: 'warm',
      skintone: 'medium',
      analysisDate: DateTime(2025, 9, 10),
    ),
  ];
  // ---------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    // Di sini kita akan menggunakan mock data terlebih dahulu.
    // Logika untuk fetch data real dari Firestore harus diimplementasikan di FirestoreService.
    _historyFuture = Future.value(_mockHistory); 
    // _historyFuture = _fetchAnalysisHistory(); // Untuk penggunaan real
  }

  // NOTE: Anda perlu mengimplementasikan fungsi ini di FirestoreService
  // Future<List<AnalysisResult>> _fetchAnalysisHistory() async {
  //   // Logika untuk mengambil data dari Firestore: Users/{uid}/analysisHistory
  //   return []; 
  // }
  
  void _sortHistory(List<AnalysisResult> data) {
    setState(() {
      data.sort((a, b) => b.analysisDate.compareTo(a.analysisDate));
    });
  }

  void _navigateToDetail(AnalysisResult result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Kirim hasil analisis ke QuizResultScreen dengan flag isHistory
        builder: (context) => QuizResultScreen(resultFromHistory: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis History', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Subtitle
              const Text(
                'Your personal color analysis history is saved here. Check past results to compare and refine your beauty choices.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Sort By Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    // Logika Sorting (saat ini hanya mengurutkan berdasarkan tanggal)
                    _historyFuture.then(_sortHistory);
                  },
                  icon: const Icon(Icons.sort, size: 24, color: Colors.black),
                  label: const Text('Sort By', style: TextStyle(color: Colors.black, fontSize: 16)),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerRight
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Daftar History
              Expanded(
                child: FutureBuilder<List<AnalysisResult>>(
                  future: _historyFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No analysis history found.'));
                    }

                    final historyList = snapshot.data!;
                    
                    return ListView.builder(
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        final result = historyList[index];
                        return HistoryCard(
                          result: result,
                          onTap: () => _navigateToDetail(result),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}