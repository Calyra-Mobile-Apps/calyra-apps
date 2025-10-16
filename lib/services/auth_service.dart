// Lokasi file: lib/services/auth_service.dart

import 'package:calyra/models/service_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Stream untuk memantau status otentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Fungsi untuk Sign In
  Future<ServiceResponse<User?>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ServiceResponse.success(credential.user);
    } on FirebaseAuthException catch (e) {
      return ServiceResponse.failure(_mapFirebaseError(e));
    }
  }

  // Fungsi untuk Sign Up
  Future<ServiceResponse<User?>> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      // 1. Buat user di Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;

      if (user != null) {
        // 2. Simpan data tambahan di Firestore
  await _firestore.collection('Users').doc(user.uid).set({
          'name': name,
          'email': email,
          'created_at': Timestamp.now(),
        });
        return ServiceResponse.success(user);
      }
      return ServiceResponse.failure('User creation failed.');
    } on FirebaseAuthException catch (e) {
      return ServiceResponse.failure(_mapFirebaseError(e));
    }
  }
  
  // Fungsi untuk Forgot Password
  Future<ServiceResponse<void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ServiceResponse.success();
    } on FirebaseAuthException catch (e) {
      return ServiceResponse.failure(_mapFirebaseError(e));
    }
  }

  Future<ServiceResponse<void>> reauthenticateUser(String oldPassword) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return ServiceResponse.failure('User is not logged in.');
    }

    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      
      // Attempt re-authentication
      await user.reauthenticateWithCredential(credential);
      
      // If re-authentication succeeds, it means the old password was correct.
      return ServiceResponse.success();
    } on FirebaseAuthException catch (e) {
      // Handles cases like 'wrong-password' or 'invalid-credential'
      return ServiceResponse.failure(_mapFirebaseError(e));
    } catch (e) {
      return ServiceResponse.failure('An unexpected error occurred during re-authentication: $e');
    }
  }

  Future<ServiceResponse<void>> updatePassword(String newPassword) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return ServiceResponse.failure('User is not logged in.');
    }

    try {
      // Re-authentication should be done BEFORE this call.
      await user.updatePassword(newPassword);
      return ServiceResponse.success();
    } on FirebaseAuthException catch (e) {
      return ServiceResponse.failure(_mapFirebaseError(e));
    } catch (e) {
      return ServiceResponse.failure('An unexpected error occurred: $e');
    }
  }

  // Fungsi untuk Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapFirebaseError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password. Please try again.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return exception.message ?? 'An unexpected error occurred. Please try again.';
    }
  }
}