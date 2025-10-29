import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/models/user_model.dart';
import 'package:calyra/screens/auth/login_screen.dart';
import 'package:calyra/screens/profile/edit_profile_screen.dart';
import 'package:calyra/screens/profile/change_password_screen.dart';
import 'package:calyra/screens/profile/analysis_history_screen.dart';
import 'package:calyra/screens/profile/legal_content_screen.dart';
import 'package:calyra/screens/profile/faq_screen.dart';
// TODO: Buat atau import layar About App jika belum ada
// import 'package/path/to/about_app_screen.dart';
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
      // Fallback if user data doesn't exist in Firestore yet
      setState(() {
        _userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? user.email?.split('@').first ?? 'Calyra User', // Use displayName if available
          email: user.email ?? 'email@example.com',
          createdAt: Timestamp.now(), // Consider fetching from user.metadata.creationTime
          avatarPath: user.photoURL ?? defaultAvatarPath, // Use photoURL if available
        );
        _isLoading = false;
      });
       // Optionally, save this initial data to Firestore if it was missing
       // _firestoreService.updateUserData(_userModel!);
    }
  }


  Future<void> _handleLogout() async {
    final navigator = Navigator.of(context); // Cache navigator

    // Show confirmation dialog
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirm Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to log out?'),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
              onPressed: () => Navigator.of(dialogContext).pop(false), // Return false on cancel
            ),
            TextButton(
              child: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(dialogContext).pop(true), // Return true on confirm
            ),
          ],
        );
      },
    );

    // Proceed only if user confirmed
    if (shouldLogout == true && mounted) {
      await _authController.signOut();

      // Use the cached navigator, check mounted again just in case
      if (mounted) {
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }


  // --- Helper function to show About App Dialog ---
  void _showAboutAppDialog() {
     // You can get app version using package_info_plus package
     // Example: final appVersion = await PackageInfo.fromPlatform().then((info) => info.version);
     const appVersion = "1.0.0"; // Placeholder version
     const buildNumber = "1"; // Placeholder build number

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.black87),
              SizedBox(width: 10),
              Text('About Calyra', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const SingleChildScrollView( // Use SingleChildScrollView for long text
            child: Column(
              mainAxisSize: MainAxisSize.min, // Important for Dialog size
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Calyra helps you discover makeup products that perfectly match your personal color analysis.'),
                SizedBox(height: 10),
                Text('Version: $appVersion ($buildNumber)'), // Display version
                SizedBox(height: 10),
                Text('© 2025 Calyra Team. All rights reserved.'), // Copyright
                 SizedBox(height: 10),

              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: <Widget>[
             TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
        backgroundColor: Colors.white, // Ensure background is white during loading
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF1B263B))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 120.0), // Padding bawah utk bottom nav bar
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
                icon: Icons.history_rounded, // Slightly different icon
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
                icon: Icons.lock_reset_rounded, // Slightly different icon
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
                icon: Icons.help_outline_rounded, // Slightly different icon
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
                icon: Icons.description_outlined, // Standard icon
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
                icon: Icons.privacy_tip_outlined, // Standard icon
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
              // --- TAMBAHAN MENU ABOUT APP ---
               _buildProfileMenu(
                 context,
                 icon: Icons.info_outline_rounded, // Icon Info
                 text: 'About App',
                 onTap: () {
                    _showAboutAppDialog(); // Panggil dialog
                    // Jika ingin navigasi ke layar baru:
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutAppScreen()));
                 },
               ),
              // --- AKHIR TAMBAHAN ---
              _buildProfileMenu(
                context,
                icon: Icons.logout_rounded, // Slightly different icon
                text: 'Logout',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: _handleLogout, // Panggil fungsi logout
              ),
              const SizedBox(height: 50), // Extra padding at the bottom if needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    final user = _userModel!;
    final avatarPath = user.avatarPath ?? defaultAvatarPath;
    final isDefaultIcon = avatarPath == defaultAvatarPath || avatarPath.isEmpty || !(avatarPath.startsWith('assets/')); // Check if it's default or invalid asset

    // Check if avatarPath is a valid asset path before trying to load it
    Widget avatarWidget;
    if (isDefaultIcon) {
       avatarWidget = const Icon(
          Icons.person_rounded, // Use rounded person icon
          size: 40,
          color: Colors.white,
        );
    } else {
        // Assume it's an asset path
        avatarWidget = Image.asset(
            avatarPath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if asset fails to load
              print("Error loading avatar asset: $avatarPath, Error: $error");
              return const Icon(Icons.person_rounded,
                  size: 40, color: Colors.white);
            },
          );
    }


    return Card(
      elevation: 3, // Slightly reduced elevation
      shadowColor: Colors.grey.withOpacity(0.3), // Softer shadow
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade300, // Lighter background
              child: ClipOval(
                child: avatarWidget, // Use the determined avatar widget
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
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600), // Slightly darker grey
                    overflow: TextOverflow.ellipsis,
                     maxLines: 1,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Navigate to EditProfileScreen and wait for result
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(currentUser: user),
                          ),
                        );
                        // If result is not null (user saved changes) and is UserModel, update UI
                        if (mounted && result != null && result is UserModel) {
                          setState(() {
                            _userModel = result;
                          });
                        } else if (mounted && result == 'refresh') {
                           // Handle potential refresh signal if needed, e.g., re-fetch from Firestore
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
                        minimumSize: Size.zero, // Adjust size to content
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

  // Consistent styling for menu items
  Widget _buildProfileMenu(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? textColor,
      Color? iconColor}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6), // Slightly reduced margin
      elevation: 2, // Slightly reduced elevation
      shadowColor: Colors.grey.withOpacity(0.2), // Softer shadow
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Adjusted padding
        leading: Icon(icon, color: iconColor ?? Colors.black54, size: 22), // Slightly smaller icon
        title: Text(text,
            style: TextStyle(
                color: textColor ?? const Color(0xFF0D1B2A),
                fontWeight: FontWeight.w600, // Consistent weight
                fontSize: 15)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, // Different arrow
            size: 16, color: textColor ?? Colors.grey[400]), // Smaller arrow
        onTap: onTap,
        dense: true, // Make ListTile more compact
      ),
    );
  }
}
