// Lokasi file: lib/services/firestore_service.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/product.dart'; // <-- 1. TAMBAHKAN IMPORT INI
import 'package:calyra/models/service_response.dart';
import 'package:calyra/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  FirestoreService({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  static const String _usersCollection = 'Users';
  static const String _analysisHistoryCollection = 'analysisHistory';
  static const String _productsCollection = 'Products'; // Diganti dari 'shades'

  Future<ServiceResponse<UserModel>> getUserData(String uid) async {
    try {
      final doc = await _db.collection(_usersCollection).doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromFirestore(doc.data()!, uid);
        return ServiceResponse.success(user);
      }
      return ServiceResponse.failure('User data not found.');
    } catch (e) {
      return ServiceResponse.failure('Error getting user data: $e');
    }
  }

  Future<ServiceResponse<void>> saveAnalysisResult(
      AnalysisResult result) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return ServiceResponse.failure('User is not logged in.');
    }

    try {
      await _db
          .collection(_usersCollection)
          .doc(user.uid)
          .collection(_analysisHistoryCollection)
          .add(result.toMap());
      return ServiceResponse.success();
    } catch (e) {
      return ServiceResponse.failure('Error saving analysis result: $e');
    }
  }

  Future<ServiceResponse<void>> updateUserData(UserModel user) async {
    try {
      final dataToUpdate = {
        'name': user.name,
        'avatarPath': user.avatarPath,
        'date_of_birth': user.dateOfBirth,
      };

      await _db.collection(_usersCollection).doc(user.uid).set(
            dataToUpdate,
            SetOptions(merge: true),
          );
      return ServiceResponse.success();
    } catch (e) {
      return ServiceResponse.failure('Error updating user data: $e');
    }
  }

  Future<ServiceResponse<List<Product>>> getProductsByBrandName(
      String brandName) async {
    try {
      // --- PERUBAHAN DI SINI ---
      final querySnapshot = await _db
          .collection(
              _productsCollection) // Menggunakan nama collection yang benar
          .where('brand_name', isEqualTo: brandName)
          .get();

      final products = querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc.data()))
          .toList();

      return ServiceResponse.success(products);
    } catch (e) {
      return ServiceResponse.failure('Error fetching products: $e');
    }
  }

  Future<ServiceResponse<List<Product>>> getProductsBySeason(
      String seasonName) async {
    try {
      // --- PERUBAHAN DI SINI ---
      final querySnapshot = await _db
          .collection(
              _productsCollection) // Menggunakan nama collection yang benar
          .where('season_name', isEqualTo: seasonName)
          .get();

      final products = querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc.data()))
          .toList();

      return ServiceResponse.success(products);
    } catch (e) {
      return ServiceResponse.failure('Error fetching products by season: $e');
    }
  }
}
