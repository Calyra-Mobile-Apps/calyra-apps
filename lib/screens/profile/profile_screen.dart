import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/models/user_model.dart';
import 'package:calyra/screens/auth/login_screen.dart';
import 'package:calyra/screens/profile/edit_profile_screen.dart';
import 'package:calyra/screens/profile/change_password_screen.dart';
import 'package:calyra/screens/profile/analysis_history_screen.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = AuthController();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _userModel;
  bool _isLoading = true;

  static const String defaultAvatarPath = 'assets/images/Logo.png';

  @override
  void initState() {
    super.initState();
    _initialiseUser();
  }

  Future<void> _initialiseUser() async {
    final user = _authController.currentUser;
    if (user == null) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
      return;
    }

    final ServiceResponse<UserModel> response =
        await _firestoreService.getUserData(user.uid);

    if (!mounted) return;

    if (response.isSuccess && response.data != null) {
      setState(() {
        _userModel = response.data!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _userModel = UserModel(
          uid: user.uid,
          name: user.email?.split('@').first ?? 'Calyra User',
          email: user.email ?? 'email@example.com',
          createdAt: Timestamp.now(),
          avatarPath: defaultAvatarPath,
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final navigator = Navigator.of(context);

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => navigator.pop(),
            ),
            TextButton(
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                navigator.pop();
                await _authController.signOut();

                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _userModel == null) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF1B263B))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "My Profile",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A)),
              ),
              const SizedBox(height: 24),
              _buildUserInfoCard(context),
              const SizedBox(height: 32),
              _buildProfileMenu(
                context,
                icon: Icons.history,
                text: 'History',
                onTap: () {
                  // Tambahkan navigasi ke halaman History
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AnalysisHistoryScreen()),
                  );
                },
              ),
              _buildProfileMenu(
                context,
                icon: Icons.lock_reset,
                text: 'Change Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen()),
                  );
                },
              ),
              _buildProfileMenu(
                context,
                icon: Icons.description_outlined,
                text: 'Terms & Conditions',
                onTap: () {/* Tambahkan aksi */},
              ),
              _buildProfileMenu(
                context,
                icon: Icons.privacy_tip_outlined,
                text: 'Privacy Policy',
                onTap: () {/* Tambahkan aksi */},
              ),
              _buildProfileMenu(
                context,
                icon: Icons.logout,
                text: 'Logout',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: _handleLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    final user = _userModel!;
    final avatarPath = user.avatarPath ?? defaultAvatarPath;
    final isDefaultIcon = avatarPath == defaultAvatarPath;

    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFFE0E0E0),
              child: ClipOval(
                child: isDefaultIcon
                  ? const Icon( // Tampilkan Icon.person jika path adalah marker default
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    )
                    : Image.asset(
                  avatarPath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person,
                        size: 40, color: Colors.white);
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(currentUser: user),
                          ),
                        );
                        if (mounted && result != null && result is UserModel) {
                          setState(() {
                            _userModel = result;
                          });
                        } else {
                          _initialiseUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? textColor,
      Color? iconColor}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Icon(icon, color: iconColor ?? Colors.black54),
        title: Text(text,
            style: TextStyle(
                color: textColor ?? const Color(0xFF0D1B2A),
                fontWeight: FontWeight.w600,
                fontSize: 15)),
        trailing: Icon(Icons.arrow_forward,
            size: 20, color: textColor ?? Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}
