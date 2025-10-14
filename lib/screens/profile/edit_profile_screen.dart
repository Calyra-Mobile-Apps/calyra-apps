// Lokasi file: lib/screens/profile/edit_profile_screen.dart
import 'package:calyra/models/user_model.dart';
import 'package:calyra/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel currentUser;

  const EditProfileScreen({super.key, required this.currentUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool _isPasswordVisible = false;
  bool _hasChanges = false;

  // Data asli dari user untuk membandingkan perubahan
  late String _originalName;
  late String _originalEmail;

  @override
  void initState() {
    super.initState();
    // Data diinisialisasi dari user yang login
    _originalName = widget.currentUser.name;
    _originalEmail = widget.currentUser.email;

    _nameController = TextEditingController(text: _originalName);
    _emailController = TextEditingController(text: _originalEmail);
    _passwordController =
        TextEditingController(text: '********'); // Placeholder untuk keamanan

    // Tambahkan listener untuk mendeteksi perubahan
    _nameController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkChanges);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkChanges() {
    // Cek apakah nama sudah berubah dari nilai asli.
    final currentName = _nameController.text.trim();
    final bool changed = currentName != _originalName;

    if (changed != _hasChanges) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate() && _hasChanges) {
      // TODO: Implementasi logika SAVE ke Firestore/Authentication
      // ... (Tampilkan loading, panggil service update, dan notifikasi)

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Simpan perubahan... (Logic to be implemented)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Untuk menampilkan panah kembali + teks, kita hanya gunakan IconButton standar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Padding horizontal
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header (Edit Profile)
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B2A)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Don't worry, only you can see your personal data. No one else will able to see it",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Foto Profil
                _buildProfileAvatar(context),
                const SizedBox(height: 40),

                // Form Input: NAME (Editable)
                CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    // Jika CustomTextFormField mendukung `readOnly`, tambahkan: readOnly: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),

                // Form Input: EMAIL (Read-Only)
                CustomTextFormField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                  prefixIcon: Icons.email_outlined,
                  // FIELD EMAIL HARUS READ-ONLY
                  // Jika CustomTextFormField mendukung, tambahkan: readOnly: true,
                  validator: (value) => null,
                ),
                const SizedBox(height: 16),

                // Form Input: PASSWORD (Read-Only Placeholder)
                CustomTextFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: '********',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_isPasswordVisible,
                  // FIELD PASSWORD HARUS READ-ONLY
                  // Jika CustomTextFormField mendukung, tambahkan: readOnly: true,
                  suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible)),
                  validator: (value) => null,
                ),
                const SizedBox(height: 50),

                // Tombol Save
                ElevatedButton(
                  onPressed: _hasChanges ? _handleSave : null,
                  style: ElevatedButton.styleFrom(
                    // Latar Hitam jika ada perubahan, Abu-abu jika tidak
                    backgroundColor:
                        _hasChanges ? Colors.black : Colors.grey[300],
                    // Teks Putih jika ada perubahan, Abu-abu gelap jika tidak
                    foregroundColor:
                        _hasChanges ? Colors.white : Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _hasChanges ? Colors.white : Colors.grey[600]),
                  ),
                ),

                // FIX: Menambahkan ruang kosong di bawah tombol agar tidak terpotong
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFE0E0E0),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // TODO: Implementasi logika ganti foto profil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Open image picker')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
