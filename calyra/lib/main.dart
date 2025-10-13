import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:calyra/firebase_options.dart';

// Fungsi utama (entry point) aplikasi.
void main() async {
  // Pastikan binding Flutter sudah diinisialisasi sebelum memanggil native code
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase menggunakan opsi default untuk platform saat ini (Web)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase successfully initialized.");
  } catch (e) {
    // Tangani error inisialisasi Firebase (penting untuk debugging web)
    print("Error initializing Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calyra App',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestHomePage(),
    );
  }
}

class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tampilan sederhana untuk menguji apakah Firebase dan Flutter berjalan
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calyra Firebase Test'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Aplikasi Berjalan di Web (Chrome)!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Cek console browser untuk status inisialisasi Firebase.',
            ),
            SizedBox(height: 20),
            // CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}