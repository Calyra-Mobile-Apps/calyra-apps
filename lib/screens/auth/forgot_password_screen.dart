// Location: lib/screens/auth/forgot_password_screen.dart

import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/widgets/custom_text_form_field.dart'; // Ensure this widget exists and is styled appropriately
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false; // State for loading indicator
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Function to send the standard Firebase password reset link
  Future<void> _passwordReset() async {
    // Validate the form first
    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if email is invalid
    }
    if (_isLoading) return; // Prevent double taps

    setState(() => _isLoading = true);

    // Call the standard password reset function from AuthController
    final ServiceResponse<void> response =
        await _authController.sendPasswordReset(_emailController.text.trim());

    if (mounted) {
      setState(() => _isLoading = false);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            // --- English Success Message ---
            content: Text('Password reset instructions sent to your email. Please check your inbox.'),
            backgroundColor: Colors.green, // Green for success
          ),
        );
        // Navigate back to the previous screen (Login Screen) after success
        Navigator.pop(context);
      } else {
        // --- English Error Message Handling ---
        String errorMessage;
        final rawMessage = response.message ?? 'An unknown error occurred.';
        // Map common Firebase errors to user-friendly messages
        if (rawMessage.contains('user-not-found') || rawMessage.contains('invalid-credential')) {
           errorMessage = 'Email not found or is invalid.';
        } else if (rawMessage.contains('network-request-failed')) {
           errorMessage = 'Network error. Please check your internet connection.';
        } else {
           errorMessage = 'Failed to send instructions. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Loading dialog is no longer used, indicator is in the button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // White background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Black back arrow
          onPressed: () => Navigator.of(context).pop(),
        ),
        // title: const Text('Forgot Password', style: TextStyle(color: Colors.black)),
        // centerTitle: true,
      ),
      backgroundColor: Colors.white, // Ensure scaffold background is white
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form( // Wrap content in a Form widget
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              // --- English UI Text ---
              const Text(
                'Forgot Password?', // Title
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A)), // Dark text color
              ),
              const SizedBox(height: 16),
              const Text(
                // English instructions
                "Enter the email associated with your account and we'll send instructions to reset your password.",
                style: TextStyle(fontSize: 16, color: Colors.grey), // Grey text color
              ),
              // --- End English UI Text ---
              const SizedBox(height: 40),
              CustomTextFormField( // Use your existing custom widget
                controller: _emailController,
                labelText: 'Email Address', // English label
                hintText: 'Enter your email address', // English hint
                prefixIcon: Icons.email_outlined, // Email icon
                validator: (value) { // Email validation
                   if (value == null || value.trim().isEmpty) {
                     return 'Email address cannot be empty'; // English error
                   }
                   // Basic email format check
                   if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
                     return 'Please enter a valid email format'; // English error
                   }
                   return null; // Return null if valid
                 },
                 // The autovalidateMode parameter is removed as it's not supported by CustomTextFormField
                 // autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _passwordReset, // Call reset function
                // --- Button Styling (Black + Grey Shadow) ---
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Height and full width
                  backgroundColor: Colors.black, // Black button background
                  foregroundColor: Colors.white, // White text
                  disabledBackgroundColor: Colors.grey[300], // Disabled background color
                  disabledForegroundColor: Colors.grey[600], // Disabled text color
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)), // Rounded corners
                  elevation: 3, // Subtle elevation
                  shadowColor: Colors.grey.withOpacity(0.4), // Modern grey shadow
                ),
                // --- End Button Styling ---
                child: _isLoading
                    ? const SizedBox( // Show loading indicator inside button
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white, // White spinner
                        ))
                    : const Text(
                        // --- English Button Text ---
                        'Send Instructions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 50), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

