import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? profileImagePath;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    String? profileImagePath,
  }) : profileImagePath = profileImagePath ?? '';

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      username: data["username"] as String? ?? '',
      email: data["email"] as String? ?? '',
      profileImagePath: data["profileImagePath"] as String? ?? '',
    );
  }

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      username: user.displayName ?? '',
      email: user.email ?? '',
      profileImagePath: user.photoURL ?? '',
    );
  }

  Map<String, dynamic> toMap(UserModel user) {
    return {
      'uid': user.uid,
      'username': user.username,
      'email': user.email,
      'profileImagePath': user.profileImagePath ?? '',
    };
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? profileImagePath,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}