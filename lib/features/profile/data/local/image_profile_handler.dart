import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageProfileHandler {
  static Future<String> saveProfileImage(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newImage = await image.copy('${appDir.path}/profile_image.jpg');
    return newImage.path; 
  }

  static Future<void> deleteProfileImage() async {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/profile_image.jpg');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
