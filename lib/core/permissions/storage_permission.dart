
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';


Future<bool> checkStoragePermission() async {
  PermissionStatus status;

  if (Platform.isIOS) {
    status = await Permission.photos.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.photos.request();
    }
  } else {
    // Android
    status = await Permission.storage.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.storage.request();
    }
  }

  if (status.isGranted) {
    print('✅ Storage permission granted');
    return true;
  } else if (status.isPermanentlyDenied) {
    print('⚠️ Storage permission permanently denied');
    await openAppSettings();
    return false;
  } else {
    await openAppSettings();
    print('❌ Storage permission denied');
    return false;
  }
}
