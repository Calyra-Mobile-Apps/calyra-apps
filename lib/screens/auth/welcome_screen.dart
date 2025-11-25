// Lokasi file: lib/screens/auth/welcome_screen.dart

import 'package:calyra/screens/quiz/take_selfie_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;

  const WelcomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background dengan Header dan Image
            Column(
              children: [
                // --- HEADER SECTION ---
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 24,
                    right: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Congratulations!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your account has been successfully registered!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- IMAGE SECTION (Full Width & Height) ---
                Expanded(
                  child: Image.asset(
                    'assets/images/onboarding_background.png',
                    fit: BoxFit.cover, 
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // --- BUTTON OVERLAY (Di atas gambar) ---
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigasi ke Take Selfie Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TakeSelfieScreen(
                          isInitialFlow: true,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 2, // Kasih sedikit shadow biar keliatan overlay
                    shadowColor: Colors.black26,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}