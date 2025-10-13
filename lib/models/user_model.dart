// Lokasi file: lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  // Factory constructor untuk membuat objek UserModel dari data Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      createdAt: data['created_at'] ?? Timestamp.now(),
    );
  }
}
