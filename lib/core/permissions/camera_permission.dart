import 'package:permission_handler/permission_handler.dart';

Future<bool> checkCameraPermission() async {
  PermissionStatus status = await Permission.camera.status;

  if (status.isGranted) {
    return true;
  } 
  else if (status.isDenied || status.isRestricted) {
    status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  } 
  else if (status.isPermanentlyDenied) {
    openAppSettings(); 
    return false;
  } 
  else {
    return false;
  }
}
