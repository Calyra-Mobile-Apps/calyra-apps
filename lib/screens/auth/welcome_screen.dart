// Lokasi file: lib/screens/auth/welcome_screen.dart

import 'package:calyra/screens/main_screen.dart';
import 'package:calyra/screens/quiz/take_selfie_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;

  const WelcomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    // Ambil nama depan saja
    final String firstName = userName.split(' ').first;

    return Scaffold(
      body: Stack(
        children: [
          // --- LAYER 1: BACKGROUND IMAGE ---
          // Gambar memenuhi seluruh layar
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome.png',
              fit: BoxFit.cover, // Agar gambar full screen (crop jika perlu)
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.white); // Fallback putih jika error
              },
            ),
          ),

          // --- LAYER 2: GRADIENT OVERLAY ---
          // Membuat efek pudar dari tengah ke bawah agar teks terbaca jelas
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.4, 1.0], // Mulai gradasi dari agak tengah
                  colors: [
                    Colors.white.withOpacity(0.0), // Atas: Transparan (Gambar terlihat)
                    Colors.white.withOpacity(0.9), // Bawah: Putih (Agar teks jelas)
                  ],
                ),
              ),
            ),
          ),

          // --- LAYER 3: KONTEN (TEKS & TOMBOL) ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Konten di bawah
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 4), // Dorong konten ke bawah (sesuaikan flex ini agar pas di area kosong gambar)
                  
                  // Ucapan Selamat Datang
                  Text(
                    'Welcome, $firstName!',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  // Deskripsi
                  const Text(
                    "Your account is ready! Let's discover your perfect color palette to enhance your natural beauty.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87, // Warna agak gelap agar kontras
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // --- TOMBOL 1: TAKE QUIZ ---
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TakeSelfieScreen(isInitialFlow: true),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5, // Sedikit bayangan agar pop-up
                      ),
                      child: const Text(
                        'Take Personal Color Quiz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // --- TOMBOL 2: SKIP TO HOME ---
                  SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MainScreen()),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.8), // Sedikit background putih transparan
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Skip to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}