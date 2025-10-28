import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:tal3a/core/permissions/camera_permission.dart';
import 'package:tal3a/core/permissions/storage_permission.dart';
import 'package:tal3a/features/profile/data/local/image_profile_handler.dart';

class ProfileController {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickProfileImageFromCamera() async {
    if (await checkCameraPermission()) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final savedPath = await ImageProfileHandler.saveProfileImage(File(image.path));
        return savedPath;
      }
    }
    return null;
  }
  
static Future<String?> pickProfileImageFromGallery() async {
  final hasPermission = await checkStoragePermission();
  if (!hasPermission) return null;

  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    final savedPath = await ImageProfileHandler.saveProfileImage(File(image.path));
    return savedPath;
  }
  return null;
}

  static Future deleteProfileImage() async {
    await ImageProfileHandler.deleteProfileImage();
  } 
}