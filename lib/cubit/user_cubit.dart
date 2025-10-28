import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/data/models/user_model.dart';
import 'package:tal3a/data/datasources/local/user_local_data.dart';
import 'package:tal3a/features/profile/data/local/image_profile_handler.dart';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null);

  Future<void>  loadUserFromLocal() async {
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
  }

  Future<void> updateProfileImage(File newImage) async {
    if (state == null) return;
    final imagePath = await ImageProfileHandler.saveProfileImage(newImage);
    final updatedUser = state!.copyWith(profileImagePath: imagePath);
    await UserLocalData().writeUserData(updatedUser);
    emit(updatedUser);
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
}
