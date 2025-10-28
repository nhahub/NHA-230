import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../constant/map_constants.dart';


class SearchService {
  final Function(List<Map<String, dynamic>>) setSearchResults;
  final Function(bool) setIsLoadingSearch;
  final Function(String) showSnackBar;

  Timer? _debounce;

  SearchService({
    required this.setSearchResults,
    required this.setIsLoadingSearch,
    required this.showSnackBar,
  });

  void searchLocation(String query, LocationData? currentLocation) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: MapConstants.searchDebounceMs), () async {
      if (query.isEmpty) {
        setSearchResults([]);
        setIsLoadingSearch(false);
        return;
      }

      if (currentLocation == null) {
        showSnackBar('Current location not available');
        return;
      }

      setIsLoadingSearch(true);

      final lat = currentLocation.latitude!;
      final lon = currentLocation.longitude!;
      final encodedQuery = Uri.encodeComponent(query);
      final viewBox =
          '${lon - MapConstants.viewBoxOffset},${lat - MapConstants.viewBoxOffset},${lon + MapConstants.viewBoxOffset},${lat + MapConstants.viewBoxOffset}';

      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=5&viewbox=$viewBox&bounded=1',
      );

      try {
        final response = await http.get(
          url,
          headers: {'User-Agent': 'FlutterApp'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as List;
          setSearchResults(data
              .map(
                (place) => {
              'name': place['display_name'],
              'lat': double.parse(place['lat']),
              'lon': double.parse(place['lon']),
            },
          )
              .toList());
          setIsLoadingSearch(false);
        } else {
          setSearchResults([]);
          setIsLoadingSearch(false);
          showSnackBar('Search failed. Please try again.');
        }
      } catch (e) {
        debugPrint('Search exception: $e');
        setSearchResults([]);
        setIsLoadingSearch(false);
        showSnackBar('Network error. Please try again.');
      }
    });
  }

  void dispose() {
    _debounce?.cancel();
  }
}