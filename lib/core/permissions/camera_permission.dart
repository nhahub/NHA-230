import 'package:permission_handler/permission_handler.dart';

Future<bool> checkCameraPermission() async {
  PermissionStatus status = await Permission.camera.status;

  if (status.isGranted) {
    print('Camera permission already granted ✅');
    return true;
  } 
  else if (status.isDenied || status.isRestricted) {
    status = await Permission.camera.request();

    if (status.isGranted) {
      print('Camera permission granted after request ✅');
      return true;
    } else {
      print('Camera permission denied ❌');
      return false;
    }
  } 
  else if (status.isPermanentlyDenied) {
    print('Camera permission permanently denied ⚠️');
    openAppSettings(); 
    return false;
  } 
  else {
    print('Unhandled permission state: $status');
    return false;
  }
}
