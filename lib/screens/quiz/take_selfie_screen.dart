// Lokasi file: lib/screens/quiz/take_selfie_screen.dart

import 'dart:typed_data'; // Import untuk Uint8List
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/home/home_screen.dart';
import 'package:calyra/screens/quiz/undertone_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TakeSelfieScreen extends StatefulWidget {
  const TakeSelfieScreen({super.key});

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen> {
  // Ubah dari File? menjadi Uint8List?
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      // Batasi ukuran gambar agar tidak terlalu besar untuk web
      maxWidth: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      // Baca file gambar sebagai bytes
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      // Simpan bytes ke provider
      if (mounted) {
        context.read<QuizProvider>().setSelfieBytes(bytes);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('Take Selfie', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Snap your face to discover your perfect color season', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(formattedDate, style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              
              GestureDetector(
                onTap: _takePicture,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    // Tampilkan gambar dari bytes menggunakan MemoryImage
                    image: _imageBytes != null ? DecorationImage(image: MemoryImage(_imageBytes!), fit: BoxFit.cover) : null,
                  ),
                  child: _imageBytes == null ? Center(child: Icon(Icons.camera_alt, size: 80, color: Colors.grey[400])) : null,
                ),
              ),

              Column(
                children: [
                  _buildInstruction(Icons.wb_sunny_outlined, 'Ensure good lighting'),
                  _buildInstruction(Icons.center_focus_strong_outlined, 'Face the camera straight'),
                  _buildInstruction(Icons.face_retouching_natural_outlined, 'Show full face'),
                ],
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _imageBytes == null ? null : () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UndertoneQuizScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                       Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    child: Text('Skip', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[800]),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

