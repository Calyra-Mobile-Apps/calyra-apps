// Lokasi file: lib/screens/auth/login_screen.dart

import 'package:calyra/screens/auth/forgot_password_screen.dart';
import 'package:calyra/screens/auth/signup_screen.dart';
import 'package:calyra/screens/main_screen.dart';
import 'package:calyra/services/auth_service.dart';
import 'package:calyra/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Import untuk firebase_auth sudah dihapus

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case "invalid-credential":
      case "wrong-password":
      case "user-not-found":
        return "Incorrect email or password. Please try again.";
      case "user-disabled":
        return "This user account has been disabled.";
      case "invalid-email":
        return "The email address is badly formatted.";
      case "network-request-failed":
        return "Network error. Please check your internet connection.";
      default:
        if (errorCode.isNotEmpty) {
          return errorCode;
        }
        return "An undefined error occurred. Please try again.";
    }
  }

  Future<void> signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final authService = AuthService();
    String? result = await authService.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) Navigator.pop(context); // Hentikan loading

    if (result == "Success") {
      // Arahkan ke Halaman Home/Main setelah berhasil login
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } else {
      // Jika gagal, tampilkan pesan error
      String errorMessage = getErrorMessage(result ?? "An undefined error occurred.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $errorMessage')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bagian build tidak perlu diubah
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              const Text('Welcome back', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A))),
              const Text('Sign In', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.grey)),
              const SizedBox(height: 30),
              Image.asset('assets/images/logo.png', height: 80),
              const SizedBox(height: 40),

              CustomTextFormField(controller: _emailController, labelText: 'Email Address', hintText: 'Enter your email address', prefixIcon: Icons.email_outlined),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                isPassword: !_isPasswordVisible,
                suffixIcon: IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible)),
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?', style: TextStyle(color: Colors.blue)),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: signInUser,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B263B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),

              const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('OR')), Expanded(child: Divider())]),
              const SizedBox(height: 24),
              
              Center(
                child: Text.rich(
                  TextSpan(text: "Don't have an account? ", style: const TextStyle(color: Colors.black), children: [
                    TextSpan(
                      text: 'Sign Up.',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
                        },
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
