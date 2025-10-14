// Lokasi file: lib/services/firestore_service.dart

import 'package:calyra/models/analysis_result.dart';
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

  static const String _usersCollection = 'users';
  static const String _analysisHistoryCollection = 'analysisHistory';

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

  Future<ServiceResponse<void>> saveAnalysisResult(AnalysisResult result) async {
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
}

