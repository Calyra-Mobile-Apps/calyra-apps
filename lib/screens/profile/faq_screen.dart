// lib/screens/profile/faq_screen.dart

import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  final List<Map<String, String>> faqData = const [
    {
      'question': 'How does Personal Color Analysis (PCA) work in Calyra?',
      'answer':
          'Calyra uses a combination of image analysis (from your selfie) to detect basic skin features, followed by an interactive quiz to determine your undertone and final seasonal color (e.g., Warm Spring, Cool Winter). The process consists of three steps: Selfie > Undertone Quiz > Seasonal Color Quiz.',
    },
    {
      'question': 'Is my selfie photo stored permanently?',
      'answer':
          'No. Your selfie photo is only stored temporarily in the app\'s session memory during the quiz process. It is used to provide visual comparison during the quiz steps and is deleted when the quiz is finished or when you log out. We do not store your raw photo on our servers.',
    },
    {
      'question': 'Why are the results approximate, not 100% accurate?',
      'answer':
          'The results are an estimate because the analysis accuracy can be affected by external factors such as lighting conditions (fluorescent vs. natural light), camera quality, and your monitor\'s color settings. For best results, take your selfie in natural daylight without heavy makeup.',
    },
    {
      'question': 'How are product recommendations generated?',
      'answer':
          'Recommendations are filtered based on the final seasonal color result obtained from your analysis. The app matches products (shades, tones) from featured brands that are scientifically aligned with your determined palette (e.g., Cool Winter palette colors).',
    },
    {
      'question': 'How can I review my previous analysis results?',
      'answer':
          'You can review all your past analysis results by visiting the "History" menu on the Profile screen. This data is permanently saved on our cloud database (Firestore).',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('FAQ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your guide to Calyra\'s Personal Color Analysis and features.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ...faqData.map((faq) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 15.0),
                        child: Text(
                          faq['answer']!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
