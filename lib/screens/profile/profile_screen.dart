import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/models/user_model.dart';
import 'package:calyra/screens/auth/login_screen.dart';
import 'package:calyra/screens/profile/edit_profile_screen.dart';
import 'package:calyra/screens/profile/change_password_screen.dart';
import 'package:calyra/screens/profile/analysis_history_screen.dart';
import 'package:calyra/screens/profile/legal_content_screen.dart';
import 'package:calyra/screens/profile/faq_screen.dart';
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
          name:
              user.displayName ?? user.email?.split('@').first ?? 'Calyra User',
          email: user.email ?? 'email@example.com',
          createdAt: Timestamp.now(),
          avatarPath: user.photoURL ?? defaultAvatarPath,
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    final navigator = Navigator.of(context);
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirm Logout',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to log out?'),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all(Colors.grey.shade700),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)) {
                      return Colors.grey.shade200;
                    }
                    return null;
                  },
                ),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              child: const Text('Cancel',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.red),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)) {
                      return Colors.red.shade100;
                    }
                    return null;
                  },
                ),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              child: const Text('Log Out',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && mounted) {
      await _authController.signOut();
      if (mounted) {
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _showAboutAppDialog() {
    const appVersion = "1.0.0";
    const buildNumber = "1";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.black87),
              SizedBox(width: 10),
              Text('About Calyra',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    'Calyra helps you discover makeup products that perfectly match your personal color analysis.'),
                SizedBox(height: 10),
                Text('Version: $appVersion ($buildNumber)'),
                SizedBox(height: 10),
                Text('© 2025 Calyra Team. All rights reserved.'),
                SizedBox(height: 10),
              ],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: <Widget>[
            TextButton(
              child: const Text('Close',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
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
        backgroundColor: Colors.white,
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF1B263B))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 50.0),
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
                icon: Icons.history_rounded,
                text: 'History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AnalysisHistoryScreen()),
                  );
                },
              ),
              _buildProfileMenu(
                context,
                icon: Icons.lock_reset_rounded,
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
                icon: Icons.help_outline_rounded,
                text: 'FAQ',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FAQScreen()));
                },
              ),
              _buildProfileMenu(
                context,
                icon: Icons.description_outlined,
                text: 'Terms & Conditions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LegalContentScreen(
                        title: 'Terms & Conditions',
                        content: kTermsAndConditionsContent,
                      ),
                    ),
                  );
                },
              ),
              _buildProfileMenu(
                context,
                icon: Icons.privacy_tip_outlined,
                text: 'Privacy Policy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LegalContentScreen(
                        title: 'Privacy Policy',
                        content: kPrivacyPolicyContent,
                      ),
                    ),
                  );
                },
              ),
              _buildProfileMenu(
                context,
                icon: Icons.info_outline_rounded,
                text: 'About App',
                onTap: () {
                  _showAboutAppDialog();
                },
              ),
              _buildProfileMenu(
                context,
                icon: Icons.logout_rounded,
                text: 'Logout',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: _handleLogout,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    final user = _userModel!;
    final avatarPath = user.avatarPath ?? defaultAvatarPath;
    final isDefaultIcon = avatarPath == defaultAvatarPath ||
        avatarPath.isEmpty ||
        !(avatarPath.startsWith('assets/'));

    Widget avatarWidget;
    if (isDefaultIcon) {
      avatarWidget = const Icon(
        Icons.person_rounded,
        size: 40,
        color: Colors.white,
      );
    } else {
      avatarWidget = Image.asset(
        avatarPath,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Error loading avatar asset: $avatarPath, Error: $error");
          return const Icon(Icons.person_rounded,
              size: 40, color: Colors.white);
        },
      );
    }

    return Card(
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade300,
              child: ClipOval(
                child: avatarWidget,
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
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
                        } else if (mounted && result == 'refresh') {
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
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: iconColor ?? Colors.black54, size: 22),
        title: Text(text,
            style: TextStyle(
                color: textColor ?? const Color(0xFF0D1B2A),
                fontWeight: FontWeight.w600,
                fontSize: 15)),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: textColor ?? Colors.grey[400]),
        onTap: onTap,
        dense: true,
      ),
    );
  }
}
