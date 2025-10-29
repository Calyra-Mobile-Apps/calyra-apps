// Lokasi file: lib/screens/auth/login_screen.dart

import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/screens/auth/forgot_password_screen.dart';
import 'package:calyra/screens/auth/signup_screen.dart';
import 'package:calyra/screens/main_screen.dart';
import 'package:calyra/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>(); // GlobalKey untuk Form

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    // Validasi sederhana
    final isValid =
        _emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _signInUser() async {
    // Validasi form sebelum sign in
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // _isFormValid check redundant if form validation passes, but kept for safety
    if (!_isFormValid) return;

    _showLoading();

    final ServiceResponse<User?> response = await _authController.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      Navigator.pop(context); // Dismiss loading dialog

      if (response.isSuccess) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        final message = response.message ??
            'An unknown error occurred. Please try again.'; // English
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $message')), // English
        );
      }
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.black)), // Spinner hitam
    );
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkFormValidity);
    _passwordController.removeListener(_checkFormValidity);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form( // Bungkus dengan Form
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                // --- English UI Text ---
                const Text('Welcome back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A))),
                const Text('Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey)),
                // --- End English UI Text ---
                const SizedBox(height: 30),
                Image.asset('assets/images/logo.png', height: 150), // Pastikan logo ada
                const SizedBox(height: 40),
                CustomTextFormField(
                    controller: _emailController,
                    labelText: 'Email Address', // English
                    hintText: 'Enter your email address', // English
                    prefixIcon: Icons.email_outlined,
                    validator: (value) { // Validator
                      if (value == null || value.trim().isEmpty) {
                        return 'Email address cannot be empty';
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
                         return 'Please enter a valid email format';
                      }
                      return null;
                    },
                 ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _passwordController,
                  labelText: 'Password', // English
                  hintText: 'Enter your password', // English
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isPasswordVisible,
                  suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility, color: Colors.grey[600]), // Icon abu
                      onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible)),
                  validator: (value) { // Validator
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 6) { // Firebase default min length
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
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
                    style: ButtonStyle(
                      // Tetapkan warna teks dasar
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      // Hapus overlay color agar tidak ada background saat hover/press
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 4)), // Sesuaikan padding jika perlu
                      minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // Hapus shape overlay jika ada sebelumnya
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Bentuk dasar (tidak terlihat)
                      ),
                      // Atur text style berdasarkan state
                      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                        (Set<MaterialState> states) {
                          // Gaya dasar
                          TextStyle style = const TextStyle(fontWeight: FontWeight.w500);
                          // Jika di-hover, tambahkan garis bawah
                          if (states.contains(MaterialState.hovered)) {
                            return style.copyWith(decoration: TextDecoration.underline);
                          }
                          // Jika ditekan (opsional, bisa sama dengan hover atau berbeda)
                          // if (states.contains(MaterialState.pressed)) {
                          //   return style.copyWith(decoration: TextDecoration.underline, color: Colors.grey[700]); // Contoh: sedikit lebih gelap saat ditekan
                          // }
                          // Default (tidak di-hover)
                          return style.copyWith(decoration: TextDecoration.none);
                        },
                      ),
                    ),
                    child: const Text(
                      'Forgot Password?', // English
                      // TextStyle di sini hanya untuk style dasar, state diatur di ButtonStyle
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isFormValid ? _signInUser : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid ? Colors.black : Colors.grey[300],
                    foregroundColor: _isFormValid ? Colors.white : Colors.grey[600],
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: Colors.grey.withOpacity(0.4),
                  ),
                  child: Text(
                      'Sign In', // English
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(height: 24),
                const Row(children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR', style: TextStyle(color: Colors.grey))),
                  Expanded(child: Divider(color: Colors.grey)),
                ]),
                const SizedBox(height: 24),
                Center(
                  child: Text.rich(
                    TextSpan(
                        text: "Don't have an account? ", // English
                        style: const TextStyle(color: Colors.black, fontSize: 15),
                        children: [
                          TextSpan(
                            text: 'Sign Up.', // English
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()));
                              },
                          ),
                        ]),
                  ),
                ),
                const SizedBox(height: 30), // Padding bawah
              ],
            ),
          ),
        ),
      ),
    );
  }
}
