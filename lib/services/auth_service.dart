// Lokasi file: lib/services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream untuk memantau status otentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Fungsi untuk Sign In
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message; // Mengembalikan pesan error jika gagal
    }
  }

  // Fungsi untuk Sign Up
  Future<String?> signUpWithEmailAndPassword(String name, String email, String password) async {
    try {
      // 1. Buat user di Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // 2. Simpan data tambahan di Firestore
        await _firestore.collection('Users').doc(user.uid).set({
          'name': name,
          'email': email,
          'created_at': Timestamp.now(),
        });
        return "Success";
      }
      return "User creation failed.";
    } on FirebaseAuthException catch (e) {
      return e.message; // Mengembalikan pesan error
    }
  }
  
  // Fungsi untuk Forgot Password
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Fungsi untuk Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}