// Lokasi file: lib/main.dart

import 'package:calyra/my_behavior.dart';
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
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Color(0xFFA3A3A3).withOpacity(0.5),
            selectionHandleColor: Colors.black,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}