// Lokasi file: lib/screens/profile/profile_screen.dart

// import 'package:calyra/screens/analysis/analysis_history_screen.dart';
import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/models/user_model.dart';
import 'package:calyra/screens/auth/login_screen.dart';
import 'package:calyra/services/firestore_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = AuthController();
  final FirestoreService _firestoreService = FirestoreService();

  String _userName = 'Calyra User';
  String _userEmail = 'email@example.com';

  @override
  void initState() {
    super.initState();
    _initialiseUser();
  }

  Future<void> _initialiseUser() async {
    final user = _authController.currentUser;
    if (user == null) return;

    setState(() {
      _userEmail = user.email ?? _userEmail;
    });

    final ServiceResponse<UserModel> response =
        await _firestoreService.getUserData(user.uid);

    if (!mounted) return;

    if (response.isSuccess && response.data != null) {
      setState(() {
        _userName = response.data!.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "My Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Kartu Informasi Pengguna
              Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _userName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userEmail,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navigasi ke EditProfileScreen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B263B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Menu
              _buildProfileMenu(
                context,
                icon: Icons.history,
                text: 'History',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const AnalysisHistoryScreen()),
                  // );
                },
              ),
              _buildProfileMenu(
                context,
                icon: Icons.description_outlined,
                text: 'Terms & Conditions',
                onTap: () {},
              ),
              _buildProfileMenu(
                context,
                icon: Icons.privacy_tip_outlined,
                text: 'Privacy Policy',
                onTap: () {},
              ),
              _buildProfileMenu(
                context,
                icon: Icons.logout,
                text: 'Logout',
                textColor: Colors.red,
                onTap: () async {
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
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                          TextButton(
                            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                            onPressed: () async {
                              Navigator.of(dialogContext).pop();
                              await _authController.signOut();
                              navigator.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat setiap item menu
  Widget _buildProfileMenu(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap, Color? textColor}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? Colors.black54),
        title: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 15)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}

