// Lokasi file: lib/services/firestore_service.dart

import 'package:calyra/models/analysis_result.dart';
import 'package:calyra/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Mengambil data pengguna dari koleksi 'users' berdasarkan UID.
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        // PERBAIKAN: Tambahkan 'uid' sebagai argumen kedua
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  /// Menyimpan hasil analisis kuis ke sub-koleksi 'analysisHistory'.
  Future<void> saveAnalysisResult(AnalysisResult result) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Jangan lakukan apa-apa jika user tidak login

    try {
      // Akses sub-koleksi 'analysisHistory' dan tambahkan dokumen baru
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('analysisHistory')
          .add({
        'seasonResult': result.seasonResult,
        'undertone': result.undertone,
        'skintone': result.skintone,
        'analysisDate': result.analysisDate,
      });
    } catch (e) {
      // Handle error jika gagal menyimpan
      print("Error saving analysis result: $e");
    }
  }
}

