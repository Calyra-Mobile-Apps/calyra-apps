// Location: lib/screens/auth/forgot_password_screen.dart

import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  bool _isFormValid = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    final isValid = _emailController.text.trim().isNotEmpty;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkFormValidity);
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _passwordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isFormValid || _isLoading) return;

    setState(() => _isLoading = true);
    final ServiceResponse<void> response =
        await _authController.sendPasswordReset(_emailController.text.trim());

    if (mounted) {
      setState(() => _isLoading = false);
      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Password reset instructions sent to your email. Please check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        String errorMessage;
        final rawMessage = response.message ?? 'An unknown error occurred.';
        if (rawMessage.contains('user-not-found') ||
            rawMessage.contains('invalid-credential')) {
          errorMessage = 'Email not found or is invalid.';
        } else if (rawMessage.contains('network-request-failed')) {
          errorMessage =
              'Network error. Please check your internet connection.';
        } else {
          errorMessage = 'Failed to send instructions. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $errorMessage'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Forgot Password?',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A)),
              ),
              const SizedBox(height: 16),
              const Text(
                "Enter the email associated with your account and we'll send instructions to reset your password.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              CustomTextFormField(
                controller: _emailController,
                labelText: 'Email Address',
                hintText: 'Enter your email address',
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email address cannot be empty';
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value.trim())) {
                    return 'Please enter a valid email format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed:
                    (_isFormValid && !_isLoading) ? _passwordReset : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor:
                      _isFormValid ? Colors.black : Colors.grey[300],
                  foregroundColor:
                      _isFormValid ? Colors.white : Colors.grey[600],
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  shadowColor: Colors.grey.withOpacity(0.4),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ))
                    : const Text(
                        'Send Instructions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
