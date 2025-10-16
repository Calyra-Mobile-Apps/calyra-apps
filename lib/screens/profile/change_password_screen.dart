// Location: lib/screens/profile/change_password_screen.dart

import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final AuthController _authController = AuthController();

  int _currentStep = 1; // Start at step 1: Enter Old Password

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;

  bool _isStep1Valid = false;
  bool _isStep2Valid = false;

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(_checkStep1Validity);
    _newPasswordController.addListener(_checkStep2Validity);
    _confirmNewPasswordController.addListener(_checkStep2Validity);
  }

  @override
  void dispose() {
    _oldPasswordController.removeListener(_checkStep1Validity);
    _newPasswordController.removeListener(_checkStep2Validity);
    _confirmNewPasswordController.removeListener(_checkStep2Validity);
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _checkStep1Validity() {
    final bool isValid = _oldPasswordController.text.isNotEmpty;
    if (isValid != _isStep1Valid) {
      setState(() => _isStep1Valid = isValid);
    }
  }

  void _checkStep2Validity() {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmNewPasswordController.text;
    final passwordsMatch = newPass == confirmPass;
    final isNewDifferentFromOld = newPass != _oldPasswordController.text;
    final passwordComplex = newPass.length >= 8 &&
        RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(newPass);

    final isValid = passwordComplex && passwordsMatch && isNewDifferentFromOld;

    if (isValid != _isStep2Valid) {
      setState(() => _isStep2Valid = isValid);
    }
  }

  Future<void> _handleReauthenticate() async {
    if (_formKey.currentState!.validate() && _isStep1Valid) {
      _showLoading('Verifying old password...');

      final response = await _authController.reauthenticateUser(
        _oldPasswordController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        if (response.isSuccess) {
          setState(() => _currentStep = 2);
          _formKey.currentState!.reset();
        } else {
          final message = response.message ?? 'Authentication failed.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Verification Failed: ${message.contains('wrong-password') ? 'Incorrect password.' : message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleUpdatePassword() async {
    if (_formKey.currentState!.validate() && _isStep2Valid) {
      _showLoading('Updating password...');

      final response = await _authController.updatePassword(
        _newPasswordController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);

        if (response.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully!')),
          );
          Navigator.pop(context);
        } else {
          final message = response.message ?? 'Update failed.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update Failed: $message'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showLoading(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 10),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_currentStep == 2) {
              setState(() => _currentStep = 1);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text('Change Password',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _currentStep == 1 ? 'Verify Old Password' : 'Set New Password',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A)),
              ),
              const SizedBox(height: 16),
              Text(
                _currentStep == 1
                    ? 'Please enter your current password to proceed to the next step.'
                    : 'Enter and confirm your new password (min 8 characters, must contain letters and numbers).',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // --- STEP 1 UI: Old Password Verification ---
              if (_currentStep == 1) ...[
                CustomTextFormField(
                  controller: _oldPasswordController,
                  labelText: 'Current Password',
                  hintText: 'Enter your current password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isOldPasswordVisible,
                  suffixIcon: IconButton(
                      icon: Icon(_isOldPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() =>
                          _isOldPasswordVisible = !_isOldPasswordVisible)),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Current password cannot be empty'
                      : null,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _isStep1Valid ? _handleReauthenticate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isStep1Valid ? Colors.black : Colors.grey[300],
                    foregroundColor:
                        _isStep1Valid ? Colors.white : Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Next',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              _isStep1Valid ? Colors.white : Colors.grey[600])),
                ),
              ],

              // --- STEP 2 UI: New Password Setting ---
              if (_currentStep == 2) ...[
                CustomTextFormField(
                  controller: _newPasswordController,
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isNewPasswordVisible,
                  suffixIcon: IconButton(
                      icon: Icon(_isNewPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() =>
                          _isNewPasswordVisible = !_isNewPasswordVisible)),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password cannot be empty';
                    if (value.length < 8)
                      return 'Password must be at least 8 characters';
                    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value))
                      return 'Must contain letters and numbers';
                    if (value == _oldPasswordController.text)
                      return 'New password must be different from the old one';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _confirmNewPasswordController,
                  labelText: 'Confirm New Password',
                  hintText: 'Confirm your new password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isConfirmNewPasswordVisible,
                  suffixIcon: IconButton(
                      icon: Icon(_isConfirmNewPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(() =>
                          _isConfirmNewPasswordVisible =
                              !_isConfirmNewPasswordVisible)),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Confirmation cannot be empty';
                    if (value != _newPasswordController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _isStep2Valid ? _handleUpdatePassword : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isStep2Valid ? Colors.black : Colors.grey[300],
                    foregroundColor:
                        _isStep2Valid ? Colors.white : Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Change Password',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              _isStep2Valid ? Colors.white : Colors.grey[600])),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
