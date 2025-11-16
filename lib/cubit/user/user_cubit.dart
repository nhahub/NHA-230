import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/data/models/user_model.dart';
import 'package:tal3a/data/datasources/local/user_local_data.dart';
import 'package:tal3a/features/profile/data/local/image_profile_handler.dart';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null);

  List<String> favoritePlacesIds = [];

  Future<void> loadUserFromLocal() async {
    final user = UserLocalData().readUserData();
    if (user != null) emit(user);
  }

  Future<void> saveUser(UserModel user) async {
    await UserLocalData().writeUserData(user);
    emit(user);
  }

  Future<void> clearUser() async {
    await UserLocalData().deleteUserData();
    emit(null);
    favoritePlacesIds.clear();
  }

  Future<void> deleteProfileImage() async {
    if (state == null) return;
    await ImageProfileHandler.deleteProfileImage();
    final updatedUser = state!.copyWith(profileImagePath: '');
    await UserLocalData().writeUserData(updatedUser);
    emit(updatedUser);
  }

  Future<void> updateUserName(String newName) async {
    if (state == null) return;
    final updatedUser = state!.copyWith(username: newName);
    await UserLocalData().writeUserData(updatedUser);
    emit(updatedUser);
  }

  Future<void> updateProfileImagePath(String imagePath) async {
    if (state == null) return;
    final updatedUser = state!.copyWith(profileImagePath: imagePath);
    await UserLocalData().writeUserData(updatedUser);
    emit(updatedUser);
  }


  Future<void> loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('likedPlaces')
        .get();

    favoritePlacesIds = snapshot.docs.map((doc) {
      return doc.id;
    }).toList();
    emit(state);
  }

  bool isFavorite(String collection, String placeId) {
    final docId = "${collection}_$placeId";
    return favoritePlacesIds.contains(docId);
  }

  Future<void> toggleFavorite({required String collection, required String placeId ,required Map<String, dynamic> placeData}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docId = "${collection}_$placeId";

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('likedPlaces')
        .doc(docId);

    if (favoritePlacesIds.contains(docId)) {
      await ref.delete();
      favoritePlacesIds.remove(docId);
    } else {
      await ref.set({
        "placeId": placeId,
        "collection": collection,
        ...placeData,
      });
      favoritePlacesIds.add(docId);
    }

    emit(state?.copyWith() ?? state);
  }





}
