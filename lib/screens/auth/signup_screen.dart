// Lokasi file: lib/screens/auth/signup_screen.dart

import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/screens/auth/login_screen.dart';
import 'package:calyra/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import untuk firebase_auth dan cloud_firestore sudah dihapus

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final AuthController _authController = AuthController();

  Future<void> _signUpUser() async {
    if (_formKey.currentState!.validate()) {
      _showLoading();

      final ServiceResponse<User?> response = await _authController.signUp(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);

        if (response.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful! Please sign in.')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        } else {
          final message = response.message ?? 'An undefined error occurred. Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign up failed: $message')),
          );
        }
      }
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bagian Widget build() ini tidak perlu diubah sama sekali.
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                const Text('Welcome Buddies!', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A))),
                const Text('Sign Up', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(height: 30),
                Image.asset('assets/images/logo.png', height: 80),
                const SizedBox(height: 40),
                
                CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                
                CustomTextFormField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    hintText: 'Enter your email address',
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email format';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),

                CustomTextFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isPasswordVisible,
                  suffixIcon: IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
return 'Password must contain both letters and numbers';
}
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  labelText: 'Password Confirmation',
                  hintText: 'Confirm your password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password confirmation cannot be empty';
                    }
                    final passwordError = _passwordController.text.isEmpty
                        ? 'Password cannot be empty'
                        : (_passwordController.text.length < 8)
                            ? 'Password must be at least 8 characters'
                            : (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(_passwordController.text))
                                ? 'Please use a combination of letters and numbers'
                                : null;
                    if (passwordError != null) {
                        return 'Tolong perbaiki password di atas.';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _signUpUser,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B263B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                
                const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('OR')), Expanded(child: Divider())]),
                const SizedBox(height: 24),
                Center(
                  child: Text.rich(
                    TextSpan(text: "Already have an account? ", style: const TextStyle(color: Colors.black), children: [
                      TextSpan(
                        text: 'Sign In.',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
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
      ),
    );
  }
}
