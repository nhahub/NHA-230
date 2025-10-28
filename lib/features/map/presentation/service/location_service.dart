import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';

import '../constant/map_constants.dart';


class LocationService {
  final MapController mapController;
  final Function(LocationData) onLocationUpdate;
  final Function(String) showSnackBar;
  final Function(LocationData) updateCurrentMarker;

  StreamSubscription<LocationData>? _locationSubscription;
  Timer? _locationUpdateTimer;

  LocationService({
    required this.mapController,
    required this.onLocationUpdate,
    required this.showSnackBar,
    required this.updateCurrentMarker,
  });

  Future<void> initLocation() async {
    final location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        showSnackBar('Location service is required');
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        showSnackBar('Location permission is required');
        return;
      }
    }

    try {
      final loc = await location.getLocation();
      onLocationUpdate(loc);
      updateCurrentMarker(loc);
      mapController.move(
        LatLng(loc.latitude!, loc.longitude!),
        MapConstants.defaultZoom,
      );
    } catch (e) {
      debugPrint('getLocation error: $e');
      showSnackBar('Failed to get current location');
    }

    _locationSubscription = location.onLocationChanged.listen((loc) {
      _locationUpdateTimer?.cancel();
      _locationUpdateTimer = Timer(
        const Duration(milliseconds: MapConstants.locationUpdateDebounceMs),
            () {
          onLocationUpdate(loc);
          updateCurrentMarker(loc);
        },
      );
    });
  }

  void moveToCurrentLocation(LocationData? currentLocation) {
    if (currentLocation != null &&
        currentLocation.latitude != null &&
        currentLocation.longitude != null) {
      mapController.move(
        LatLng(currentLocation.latitude!, currentLocation.longitude!),
        MapConstants.defaultZoom,
      );
    } else {
      showSnackBar('Current location not available');
    }
  }

  void dispose() {
    _locationSubscription?.cancel();
    _locationUpdateTimer?.cancel();
  }
}