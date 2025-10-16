// Lokasi file: lib/main.dart

import 'package:calyra/my_behavior.dart'; // <-- TAMBAHKAN IMPORT INI
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CalyraApp());
}

class CalyraApp extends StatelessWidget {
  const CalyraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QuizProvider>(
          create: (_) => QuizProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Calyra',
        debugShowCheckedModeBanner: false,
        // --- MODIFIKASI DI SINI ---
        // Menambahkan ScrollConfiguration untuk menghilangkan efek glow
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        // -------------------------
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}