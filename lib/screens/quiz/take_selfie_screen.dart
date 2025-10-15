// Lokasi file: lib/screens/quiz/take_selfie_screen.dart

import 'dart:typed_data';

import 'package:calyra/providers/quiz_provider.dart';
import 'package:calyra/screens/main_screen.dart';
import 'package:calyra/screens/quiz/undertone_quiz_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  CameraController? _cameraController;
  Future<void>? _initializeCameraFuture;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (!mounted) return;

      if (cameras.isEmpty) {
        setState(() {
          _cameraError = 'No camera device found.';
        });
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
    } catch (e) {
      await _cameraController?.dispose();
      if (!mounted) return;
      setState(() {
        _cameraController = null;
        _initializeCameraFuture = null;
        _cameraError = 'Failed to initialise camera: $e';
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
      setState(() {
        _imageBytes = bytes;
      });
      context.read<QuizProvider>().setSelfieBytes(bytes);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = 'Failed to capture image: $e';
      });
    }
  }

  Future<void> _captureMobileImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      if (!mounted) return;
      setState(() {
        _imageBytes = bytes;
      });
      context.read<QuizProvider>().setSelfieBytes(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('Take Selfie', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Snap your face to discover your perfect color season',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text(
                              formattedDate,
                              style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _buildCaptureArea(),
                    Column(
                      children: [
                        _buildInstruction(Icons.wb_sunny_outlined, 'Ensure good lighting'),
                        _buildInstruction(Icons.center_focus_strong_outlined, 'Face the camera straight'),
                        _buildInstruction(Icons.face_retouching_natural_outlined, 'Show full face'),
                      ],
                    ),
                    if (kIsWeb)
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _cameraController == null ? null : _captureWebImage,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Capture'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                          if (_cameraError != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _cameraError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: _imageBytes == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const UndertoneQuizScreen()),
                                  );
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
                            context.read<QuizProvider>().resetQuiz();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const MainScreen()),
                              (route) => false,
                            );
                          },
                          child: Text('Skip', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
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
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.w500)),
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
            ? DecorationImage(image: MemoryImage(_imageBytes!), fit: BoxFit.cover)
            : null,
      ),
      child: _imageBytes == null
          ? Center(child: Icon(Icons.camera_alt, size: 80, color: Colors.grey[400]))
          : null,
    );

    if (!kIsWeb) {
      return GestureDetector(
        onTap: _captureMobileImage,
        child: preview,
      );
    }

    if (_imageBytes != null) {
      return preview;
    }

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
          child: Text(
            _cameraError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
        ),
      );
    }

    final controller = _cameraController;
    final initFuture = _initializeCameraFuture;

    if (controller == null || initFuture == null) {
      return const SizedBox(
        width: 240,
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }

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