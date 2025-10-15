// Lokasi file: lib/screens/profile/edit_profile_screen.dart
import 'package:calyra/models/user_model.dart';
import 'package:calyra/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:calyra/models/service_response.dart';
import 'package:intl/intl.dart';

const List<String> availableAvatars = [
  'assets/images/B1.png',
  'assets/images/B2.png',
  'assets/images/B3.png',
  'assets/images/G1.png',
  'assets/images/G2.png',
  'assets/images/G3.png',
  'assets/images/G4.png',
  'assets/images/G5.png',
  'assets/images/G6.png',
];

const String defaultAvatarPath = 'assets/images/Logo.png';

class EditProfileScreen extends StatefulWidget {
  final UserModel currentUser;

  const EditProfileScreen({super.key, required this.currentUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  DateTime? _selectedDateOfBirth;
  late DateTime? _originalDateOfBirth;
  late TextEditingController _dobController;

  bool _hasChanges = false;

  late String _originalName;
  late String _originalEmail;
  late String _originalAvatarPath;
  String _selectedAvatarPath = defaultAvatarPath;

  @override
  void initState() {
    super.initState();
    _originalName = widget.currentUser.name;
    _originalEmail = widget.currentUser.email;
    _originalAvatarPath = widget.currentUser.avatarPath ?? defaultAvatarPath;
    _selectedAvatarPath = _originalAvatarPath;

  _originalDateOfBirth = widget.currentUser.dateOfBirth?.toDate();
    _selectedDateOfBirth = _originalDateOfBirth;
    _dobController = TextEditingController(
      text: _originalDateOfBirth == null
          ? ''
          : DateFormat('dd MMMM yyyy').format(_originalDateOfBirth!),
    );

    _nameController = TextEditingController(text: _originalName);
    _emailController = TextEditingController(text: _originalEmail);
    _nameController.addListener(_checkChanges);
    _dobController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkChanges);
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _checkChanges() {
    final nameChanged = _nameController.text.trim() != _originalName;
    final avatarChanged = _selectedAvatarPath != _originalAvatarPath;
    final dobChanged = _selectedDateOfBirth != _originalDateOfBirth;

    final bool changed = nameChanged || avatarChanged || dobChanged;

    if (changed != _hasChanges) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime(2000), // Default 2000 jika null
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      confirmText: 'SELECT',
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
        _dobController.text = DateFormat('dd MMMM yyyy').format(picked);
        _checkChanges();
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate() && _hasChanges) {
      _showLoading();

      // Konversi DateTime ke Timestamp untuk Firestore
      final Timestamp? dobTimestamp = _selectedDateOfBirth == null
          ? null
          : Timestamp.fromDate(_selectedDateOfBirth!);

      final updatedUser = widget.currentUser.copyWith(
        name: _nameController.text.trim(),
        avatarPath: _selectedAvatarPath,
        dateOfBirth: dobTimestamp, // BARU: Sertakan tanggal lahir
      );

      final ServiceResponse<void> response = 
          await _firestoreService.updateUserData(updatedUser);

      if (!mounted) return;
      Navigator.pop(context);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
          ),
        );
        Navigator.pop(context, updatedUser); 
      } else {
        final message = response.message ?? 'An undefined error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $message'),
            backgroundColor: Colors.red,
          ),
        );
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

  void _showAvatarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Choose Your Avatar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B2A))),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 kolom
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: availableAvatars.length,
                itemBuilder: (context, index) {
                  final path = availableAvatars[index];
                  final isSelected = path == _selectedAvatarPath;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatarPath = path;
                        _checkChanges();
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 3)
                            : Border.all(color: Colors.grey.shade300, width: 1),
                        color: Colors.grey[200],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          path,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey[600]));
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Text('Back', style: TextStyle(color: Colors.black))),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                _buildProfileAvatar(context),
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
                  validator: (value) => null,
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date of Birth',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true, 
                      onTap: () => _selectDateOfBirth(context),
                      decoration: InputDecoration(
                        hintText: 'Select your date of birth',
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                        filled: true,
                        fillColor: const Color(0xFFF7F8F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _hasChanges ? _handleSave : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _hasChanges ? Colors.black : Colors.grey[300],
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
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    final currentAvatarPath = _selectedAvatarPath;
    final isDefaultIcon = currentAvatarPath == defaultAvatarPath;

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFE0E0E0),
            child: ClipOval(
              child: isDefaultIcon
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    )
                  : Image.asset(
                      currentAvatarPath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person,
                            size: 50, color: Colors.white);
                      },
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _showAvatarPicker(context),
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
