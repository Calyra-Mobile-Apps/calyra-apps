// Lokasi file: lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final Timestamp createdAt;
  final String? avatarPath;
  final Timestamp? dateOfBirth;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.avatarPath,
    this.dateOfBirth, // BARU
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      createdAt: data['created_at'] ?? Timestamp.now(),
      avatarPath: data['avatarPath'] as String?,
      dateOfBirth: data['date_of_birth'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'created_at': createdAt,
      'avatarPath': avatarPath,
      'date_of_birth': dateOfBirth,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    Timestamp? createdAt,
    String? avatarPath,
    Timestamp? dateOfBirth,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      avatarPath: avatarPath ?? this.avatarPath,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
