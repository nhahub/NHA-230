import 'package:geolocator/geolocator.dart';

class LocationService {
  final Function(Position) onLocationUpdate;
  final Function(String) showSnackBar;
  final Function(Position) updateCurrentMarker;

  LocationService({
    required this.onLocationUpdate,
    required this.showSnackBar,
    required this.updateCurrentMarker,
  });

  Future<void> initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showSnackBar('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSnackBar('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showSnackBar('Location permissions are permanently denied');
        return;
      }


      Position position = await Geolocator.getCurrentPosition();
      onLocationUpdate(position);
      updateCurrentMarker(position);
    } catch (e) {
      showSnackBar('Error getting location: $e');
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      showSnackBar('Error getting current location: $e');
      return null;
    }
  }
}