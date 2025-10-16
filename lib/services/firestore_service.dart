// Lokasi file: lib/services/firestore_service.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/product.dart';
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
  static const String _productsCollection = 'Products';

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

  Future<ServiceResponse<List<AnalysisResult>>> getAnalysisHistory() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return ServiceResponse.failure('User is not logged in.');
    }

    try {
      final querySnapshot = await _db
          .collection(_usersCollection)
          .doc(user.uid)
          .collection(_analysisHistoryCollection)
          .orderBy('analysisDate', descending: true)
          .get();

      final history = querySnapshot.docs
          .map((doc) => AnalysisResult.fromFirestore(doc.data()))
          .toList();

      return ServiceResponse.success(history);
    } catch (e) {
      return ServiceResponse.failure('Error fetching analysis history: $e');
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
      final querySnapshot = await _db
          .collection(_productsCollection)
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
      final querySnapshot = await _db
          .collection(_productsCollection)
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

// --- FUNGSI UTAMA YANG DIPERBARUI TOTAL ---
  Future<ServiceResponse<List<Product>>> getRecommendedProducts({
    required String brandName,
    required String undertone,
    required String season,
    required String skintoneGroupId,
  }) async {
    try {
      final skintoneId = int.tryParse(skintoneGroupId) ?? 0;

      // 1. Definisikan tiga query terpisah
      final queryUndertone = _db
          .collection(_productsCollection)
          .where('brand_name', isEqualTo: brandName)
          .where('undertone_name', isEqualTo: undertone)
  Future<ServiceResponse<List<Product>>> getProductsByBrandAndSeason(
      String brandName, String seasonName) async {
    try {
      final querySnapshot = await _db
          .collection(_productsCollection)
          .where('brand_name', isEqualTo: brandName)
          .where('season_name', isEqualTo: seasonName)
          .get();

      final querySeason = _db
          .collection(_productsCollection)
          .where('brand_name', isEqualTo: brandName)
          .where('season_name', isEqualTo: season)
          .get();

      final querySkintone = _db
          .collection(_productsCollection)
          .where('brand_name', isEqualTo: brandName)
          .where('skintone_group_id', isEqualTo: skintoneId)
          .get();

      // 2. Jalankan semua query secara bersamaan
      final results = await Future.wait([
        queryUndertone,
        querySeason,
        querySkintone,
      ]);

      // 3. Gabungkan hasilnya dan hapus duplikat
      final Map<String, Product> uniqueProducts = {};

      for (final querySnapshot in results) {
        for (final doc in querySnapshot.docs) {
          final product = Product.fromFirestore(doc.data());
          // Menggunakan product_id sebagai kunci untuk memastikan keunikan
          uniqueProducts[product.productId] = product;
        }
      }

      return ServiceResponse.success(uniqueProducts.values.toList());
      
    } catch (e) {
      return ServiceResponse.failure(
          'Error fetching recommended products: $e');
    }
  }

  Future<ServiceResponse<List<Product>>> getAllProducts() async {
    try {
      final querySnapshot = await _db.collection(_productsCollection).get();
      final products = querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc.data()))
          .toList();
      return ServiceResponse.success(products);
    } catch (e) {
      return ServiceResponse.failure('Error fetching all products: $e');
    }
  }
}
