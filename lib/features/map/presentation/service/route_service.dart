import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../constant/map_constants.dart';

class RouteService {
  final Function(bool) setIsLoadingRoute;
  final Function(List<LatLng>) setRoutePoints;
  final Function(bool) setShowRoute;
  final Function(double, double) setRouteInfo;
  final Function(String) showSnackBar;

  RouteService({
    required this.setIsLoadingRoute,
    required this.setRoutePoints,
    required this.setShowRoute,
    required this.setRouteInfo,
    required this.showSnackBar,
  });

  Future<void> fetchRoute(
    LocationData? currentLocation,
    LatLng destination,
  ) async {
    if (currentLocation == null) {
      showSnackBar('Current location not available');
      return;
    }

    setIsLoadingRoute(true);

    final start = LatLng(currentLocation.latitude!, currentLocation.longitude!);

    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=${MapConstants.apiKey}&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // تأكدي أن البيانات موجودة
        if (data['features'] != null &&
            data['features'].isNotEmpty &&
            data['features'][0]['geometry'] != null &&
            data['features'][0]['properties'] != null) {
          final List<dynamic> coords =
              data['features'][0]['geometry']['coordinates'];
          final newPoints = coords.map((c) => LatLng(c[1], c[0])).toList();

          final summary = data['features'][0]['properties']['summary'];
          final distance = summary['distance']?.toDouble() ?? 0.0;
          final duration = summary['duration']?.toDouble() ?? 0.0;

          // تأكدي أن القيم صحيحة قبل التحديث
          if (distance > 0 && duration > 0) {
            setRoutePoints(newPoints);
            setShowRoute(true);
            setRouteInfo(distance, duration);
            setIsLoadingRoute(false);
            return;
          }
        }
      }

      setIsLoadingRoute(false);
      showSnackBar('Could not find valid route');
    } catch (e) {
      debugPrint('Route exception: $e');
      setIsLoadingRoute(false);
      showSnackBar('Network error. Please try again.');
    }
  }
}
