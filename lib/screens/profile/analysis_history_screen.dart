// lib/screens/profile/analysis_history_screen.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/service_response.dart';
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

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchAnalysisHistory();
  }

  Future<List<AnalysisResult>> _fetchAnalysisHistory() async {
    final ServiceResponse<List<AnalysisResult>> response =
        await _firestoreService.getAnalysisHistory();

    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message ?? 'Failed to load history.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return [];
  }

  void _navigateToDetail(AnalysisResult result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(resultFromHistory: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis History',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your personal color analysis history is saved here. Check past results to compare and refine your beauty choices.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<AnalysisResult>>(
                  future: _historyFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('An error occurred: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // --- UI KOSONG DITAMPILKAN DI SINI ---
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty.png',
                              width: 150,
                              height: 150,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'No Analysis History Yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D1B2A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your past color analysis results will\nappear here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
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
