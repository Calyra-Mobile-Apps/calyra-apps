import 'package:calyra/models/service_response.dart';
import 'package:calyra/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  AuthController({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<ServiceResponse<User?>> signIn(String email, String password) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  Future<ServiceResponse<User?>> signUp(
    String name,
    String email,
    String password,
  ) {
    return _authService.signUpWithEmailAndPassword(name, email, password);
  }

  Future<ServiceResponse<void>> sendPasswordReset(String email) {
    return _authService.sendPasswordResetEmail(email);
  }

  Future<void> signOut() {
    return _authService.signOut();
  }
}
