import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tal3a/core/core.dart';


class RouteService {
  final Function(bool) setIsLoadingRoute;
  final Function(Set<Polyline>) setPolylines;
  final Function(bool) setShowRoute;
  final Function(double, double) setRouteInfo;
  final Function(String) showSnackBar;

  RouteService({
    required this.setIsLoadingRoute,
    required this.setPolylines,
    required this.setShowRoute,
    required this.setRouteInfo,
    required this.showSnackBar,
  });

  Future<void> fetchRoute(LatLng origin, LatLng destination) async {
    setIsLoadingRoute(true);

    try {
      final response = await http.get(
        Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/'
              '${origin.longitude},${origin.latitude};'
              '${destination.longitude},${destination.latitude}'
              '?overview=full&geometries=polyline',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok') {
          final route = data['routes'][0];
          final distance = route['distance'] as double;
          final duration = route['duration'] as double;

          final points = _decodePolyline(route['geometry']);

          setRouteInfo(distance, duration);
          setPolylines({
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: AppColors.primaryBlue,
              width: 5,
            ),
          });
          setShowRoute(true);
        }
      }
    } catch (e) {
      showSnackBar('Error fetching route: $e');
    } finally {
      setIsLoadingRoute(false);
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}