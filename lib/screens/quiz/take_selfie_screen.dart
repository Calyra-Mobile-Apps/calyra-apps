// Lokasi file: lib/screens/quiz/take_selfie_screen.dart

import 'dart:typed_data';
import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/main_screen.dart';
import 'package:calyra/screens/quiz/undertone_quiz_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, ByteData; // Tambahan import
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TakeSelfieScreen extends StatefulWidget {
  final bool isInitialFlow;
  const TakeSelfieScreen({super.key, this.isInitialFlow = false});

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen> {
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  CameraController? _cameraController;
  Future<void>? _initializeCameraFuture;
  String? _cameraError;
  final double _bottomNavbarHeightPadding = 100.0;

  final double _fullBottomPadding = 120.0;
  final double _minimalBottomPadding = 40.0;

  @override
  void initState() {
    super.initState();
    // Coba inisialisasi kamera, tapi jangan blokir UI jika gagal
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (kIsWeb) {
        // Logika inisialisasi kamera Web
        final cameras = await availableCameras();
        if (!mounted) return;

        if (cameras.isEmpty) {
          setState(() => _cameraError = 'No camera device found.');
          return;
        }

        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        final controller = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        final initFuture = controller.initialize();
        setState(() {
          _cameraController = controller;
          _initializeCameraFuture = initFuture;
          _cameraError = null;
        });

        await initFuture;
        if (!mounted) return;
        setState(() {});
      } else {
        // Di Mobile kadang tidak butuh inisialisasi controller di awal
        // jika hanya mengandalkan ImagePicker, tapi kita biarkan kosong/default.
      }
    } catch (e) {
      // Jangan dispose jika belum terbentuk, set error saja
      if (!mounted) return;
      setState(() {
        _cameraError = 'Camera not available (Testing Mode)';
      });
    }
  }

  Future<void> _captureWebImage() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    try {
      final picture = await controller.takePicture();
      final bytes = await picture.readAsBytes();
      if (!mounted) return;
      _setImage(bytes);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'Failed to capture image: $e';
      });
    }
  }

  Future<void> _captureMobileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        if (!mounted) return;
        _setImage(bytes);
      }
    } catch (e) {
       // Error handling jika kamera gagal dibuka
       setState(() => _cameraError = 'Camera error: $e');
    }
  }

  // --- FITUR BARU: Load Gambar Dummy untuk Testing ---
  Future<void> _loadTestImage() async {
    try {
      // Menggunakan Logo.png sebagai gambar dummy pengganti selfie
      // Pastikan path ini benar ada di assets Anda
      final ByteData bytesData = await rootBundle.load('assets/images/Logo.png');
      final Uint8List bytes = bytesData.buffer.asUint8List();
      
      if (!mounted) return;
      _setImage(bytes);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test image loaded! Press Next.')),
      );
    } catch (e) {
      debugPrint("Error loading test image: $e");
      setState(() => _cameraError = "Failed to load test image");
    }
  }

  void _setImage(Uint8List bytes) {
    setState(() {
      _imageBytes = bytes;
    });
    context.read<QuizProvider>().setSelfieBytes(bytes);
  }

  void _handleSkip(BuildContext context) {
    context.read<QuizProvider>().resetQuiz();
    if (widget.isInitialFlow) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('d MMMM yyyy').format(DateTime.now());

    final double currentBottomPadding =
        widget.isInitialFlow ? _minimalBottomPadding : _fullBottomPadding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding:
                  EdgeInsets.fromLTRB(24.0, 20.0, 24.0, currentBottomPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight -
                        _bottomNavbarHeightPadding +
                        40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('Take Selfie',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Snap your face to discover your perfect color season',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // --- CAPTURE AREA ---
                    _buildCaptureArea(),

                    Column(
                      children: [
                        _buildInstruction(
                            Icons.wb_sunny_outlined, 'Ensure good lighting'),
                        _buildInstruction(Icons.center_focus_strong_outlined,
                            'Face the camera straight'),
                        _buildInstruction(
                            Icons.face_retouching_natural_outlined,
                            'Show full face'),
                      ],
                    ),
                    
                    // --- TOMBOL CAPTURE WEB ---
                    if (kIsWeb)
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _cameraController == null
                                ? null
                                : _captureWebImage,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Capture'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                          if (_cameraError != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _cameraError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 12),
                            ),
                          ],
                        ],
                      ),

                    // --- TOMBOL NAVIGASI (Next, Use Test Photo, Skip) ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Tombol NEXT
                        ElevatedButton(
                          onPressed: _imageBytes == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UndertoneQuizMainScreen()),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Next',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        
                        // --- TOMBOL BARU: USE TEST PHOTO ---
                        if (_imageBytes == null) // Hanya muncul jika belum ada foto
                          OutlinedButton.icon(
                            onPressed: _loadTestImage,
                            icon: const Icon(Icons.image),
                            label: const Text("Use Test Photo (Skip Camera)"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          
                        const SizedBox(height: 8),
                        if (widget.isInitialFlow)
                          TextButton(
                            onPressed: () => _handleSkip(context),
                            child: Text('Quit Quiz',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 16)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[800]),
          const SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCaptureArea() {
    final preview = Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        image: _imageBytes != null
            ? DecorationImage(
                image: MemoryImage(_imageBytes!), fit: BoxFit.cover)
            : null,
      ),
      child: _imageBytes == null
          ? Center(
              child: Icon(Icons.camera_alt, size: 80, color: Colors.grey[400]))
          : null,
    );

    // Jika di Mobile (dan bukan Web), tap area untuk buka kamera
    if (!kIsWeb) {
      return GestureDetector(
        onTap: _captureMobileImage,
        child: preview,
      );
    }

    // Jika sudah ada gambar (Web/Mobile), tampilkan preview statis
    if (_imageBytes != null) {
      return preview;
    }

    // Jika Error kamera (Web)
    if (_cameraError != null) {
      return Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[100],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const Icon(Icons.broken_image, size: 40, color: Colors.grey),
               const SizedBox(height: 8),
               Text(
                _cameraError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    final controller = _cameraController;
    final initFuture = _initializeCameraFuture;

    // Loading state kamera (Web)
    if (controller == null || initFuture == null) {
      return const SizedBox(
        width: 240,
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Preview Kamera (Web)
    return FutureBuilder<void>(
      future: initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            width: 240,
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SizedBox(
          width: 240,
          height: 240,
          child: ClipOval(
            child: CameraPreview(controller),
          ),
        );
      },
    );
  }
}