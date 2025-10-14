import 'package:calyra/controllers/auth_controller.dart';
import 'package:calyra/models/service_response.dart';
import 'package:calyra/models/user_model.dart';
import 'package:calyra/screens/auth/login_screen.dart';
import 'package:calyra/screens/profile/edit_profile_screen.dart';
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

    // Mengambil data lengkap dari Firestore
    final ServiceResponse<UserModel> response =
        await _firestoreService.getUserData(user.uid);

    if (!mounted) return;

    if (response.isSuccess && response.data != null) {
      setState(() {
        _userModel = response.data!;
        _isLoading = false;
      });
    } else {
      // Fallback jika gagal mengambil data dari Firestore
      setState(() {
        _userModel = UserModel(
          uid: user.uid,
          name: user.email?.split('@').first ?? 'Calyra User',
          email: user.email ?? 'email@example.com',
          createdAt: Timestamp.now(), // Menggunakan waktu saat ini sebagai fallback
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
    // Cek _userModel selain _isLoading untuk memastikan data sudah ada
    if (_isLoading || _userModel == null) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF1B263B))),
      );
    }

    return Scaffold(
      // Background page diatur menjadi putih
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

              // Kartu Informasi Pengguna (Card Profile)
              _buildUserInfoCard(context),
              const SizedBox(height: 32),

              // Daftar Menu
              _buildProfileMenu(
                context,
                icon: Icons.history,
                text: 'History',
                onTap: () {
                  // TODO: Implementasi navigasi ke AnalysisHistoryScreen
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

  // Widget untuk Card Informasi Pengguna
  Widget _buildUserInfoCard(BuildContext context) {
    // Memastikan _userModel tidak null (sudah dicek di build)
    final user = _userModel!; 

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
            // Avatar di Kiri
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // Nama, Email, dan Tombol di Kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name, // Menggunakan data dari _userModel
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email, // Menggunakan data dari _userModel
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        // --- NAVIGASI KE EDIT PROFILE PAGE ---
                        // Cukup meneruskan objek _userModel yang sudah ada
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                                currentUser: user),
                          ),
                        );
                      },
                      // Tombol Edit Profile: Hitam dengan teks putih
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

  // Widget untuk setiap item menu
  Widget _buildProfileMenu(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? textColor,
      Color? iconColor}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4, // Menambahkan elevasi agar timbul
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
        // Menggunakan Icons.arrow_forward sesuai gambar
        trailing: Icon(Icons.arrow_forward,
            size: 20, color: textColor ?? Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}