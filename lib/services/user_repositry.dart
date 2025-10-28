import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tal3a/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  /// Fetch complete user data from Firestore (includes username)
  Future<UserModel> getUserFromFirestore(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserModel.fromMap(uid, docSnapshot.data()!);
      } else {
        throw "No user found";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateUsername(UserModel updatedUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(updatedUser.uid)
        .update({'username': updatedUser.username});
  }
}
