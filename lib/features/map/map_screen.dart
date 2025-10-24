import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:tal3a/core/core.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LocationData? currentLocation;
  List<Marker> markers = [];
  List<LatLng> routePoints = [];
  bool showRoute = true;

  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool searching = false;
  bool isLoadingRoute = false;
  bool isLoadingSearch = false;

  StreamSubscription<LocationData>? _locationSubscription;
  Timer? _debounce;
  Timer? _locationUpdateTimer;

  // Constants
  static const double _defaultZoom = 15.0;
  static const double _viewBoxOffset = 0.5;
  static const int _searchDebounceMs = 500;
  static const int _locationUpdateDebounceMs = 300;

  final String apiKey =
      "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjAxMjRmYzA4MWRjMzQzMzY4MmViYWE1N2IwMTgyN2MyIiwiaCI6Im11cm11cjY0In0=";

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _locationUpdateTimer?.cancel();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _showSnackBar('Location service is required');
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _showSnackBar('Location permission is required');
        return;
      }
    }

    try {
      final loc = await location.getLocation();
      if (mounted) {
        setState(() {
          currentLocation = loc;
          _updateCurrentMarker(loc);
          _mapController.move(
            LatLng(loc.latitude!, loc.longitude!),
            _defaultZoom,
          );
        });
      }
    } catch (e) {
      debugPrint('getLocation error: $e');
      _showSnackBar('Failed to get current location');
    }

    _locationSubscription = location.onLocationChanged.listen((loc) {
      _locationUpdateTimer?.cancel();
      _locationUpdateTimer = Timer(
        const Duration(milliseconds: _locationUpdateDebounceMs),
            () {
          if (mounted) {
            setState(() {
              currentLocation = loc;
              _updateCurrentMarker(loc);
            });
          }
        },
      );
    });
  }

  void _updateCurrentMarker(LocationData loc) {
    markers.removeWhere((m) => m.key == const ValueKey('current'));
    if (loc.latitude != null && loc.longitude != null) {
      markers.add(
        Marker(
          key: const ValueKey('current'),
          width: 112.w,
          height: 112.w,
          point: LatLng(loc.latitude!, loc.longitude!),
          child: _buildCurrentLocationMarker(),
        ),
      );
    }
  }

  Widget _buildCurrentLocationMarker() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue,
              blurRadius: 16.r,
            ),
          ],
        ),
        child: Icon(
          Icons.my_location,
          size: 36.sp,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildDestinationPin() {
    return SizedBox(
      width: 100.w,
      height: 140.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryBlue, width: 4.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12.r,
                ),
              ],
            ),
            child: Icon(
              Icons.place,
              size: 36.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          Transform.rotate(
            angle: 3.1416 / 4,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.r,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addDestination(LatLng point) {
    markers.removeWhere((m) => m.key == const ValueKey('destination'));
    markers.add(
      Marker(
        key: const ValueKey('destination'),
        width: 112.w,
        height: 152.h,
        point: point,
        child: _buildDestinationPin(),
      ),
    );
    _fetchRoute(point);
  }

  Future<void> _fetchRoute(LatLng destination) async {
    if (currentLocation == null) {
      _showSnackBar('Current location not available');
      return;
    }

    setState(() => isLoadingRoute = true);

    final start = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> coords =
        data['features'][0]['geometry']['coordinates'];
        final newPoints = coords.map((c) => LatLng(c[1], c[0])).toList();
        if (mounted) {
          setState(() {
            routePoints = newPoints;
            showRoute = true;
            isLoadingRoute = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => isLoadingRoute = false);
          _showSnackBar('Could not find route');
        }
      }
    } catch (e) {
      debugPrint('Route exception: $e');
      if (mounted) {
        setState(() => isLoadingRoute = false);
        _showSnackBar('Network error. Please try again.');
      }
    }
  }

  Future<void> _searchLocation(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: _searchDebounceMs), () async {
      if (query.isEmpty) {
        setState(() {
          searchResults = [];
          isLoadingSearch = false;
        });
        return;
      }

      if (currentLocation == null) {
        _showSnackBar('Current location not available');
        return;
      }

      setState(() => isLoadingSearch = true);

      final lat = currentLocation!.latitude!;
      final lon = currentLocation!.longitude!;
      final encodedQuery = Uri.encodeComponent(query);

      final viewBox =
          '${lon - _viewBoxOffset},${lat - _viewBoxOffset},${lon + _viewBoxOffset},${lat + _viewBoxOffset}';

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
          if (mounted) {
            setState(() {
              searchResults = data
                  .map(
                    (place) => {
                  'name': place['display_name'],
                  'lat': double.parse(place['lat']),
                  'lon': double.parse(place['lon']),
                },
              )
                  .toList();
              isLoadingSearch = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              searchResults = [];
              isLoadingSearch = false;
            });
            _showSnackBar('Search failed. Please try again.');
          }
        }
      } catch (e) {
        debugPrint('Search exception: $e');
        if (mounted) {
          setState(() {
            searchResults = [];
            isLoadingSearch = false;
          });
          _showSnackBar('Network error. Please try again.');
        }
      }
    });
  }

  void _moveToCurrent() {
    if (currentLocation != null &&
        currentLocation!.latitude != null &&
        currentLocation!.longitude != null) {
      _mapController.move(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        _defaultZoom,
      );
    } else {
      _showSnackBar('Current location not available');
    }
  }

  void _toggleRoute() {
    setState(() => showRoute = !showRoute);
  }

  void _clearDestination() {
    setState(() {
      markers.removeWhere((m) => m.key == const ValueKey('destination'));
      routePoints = [];
      showRoute = false;
    });
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          margin: EdgeInsets.all(32.w),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: GestureDetector(
        onTap: () {
          if (searching) {
            setState(() {
              searching = false;
              searchResults = [];
            });
          }
        },
        child: Stack(
          children: [
            // Map Layer
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(30.0444, 31.2357),
                initialZoom: 13.0,
                onTap: (tap, latlng) {
                  _addDestination(latlng);
                  if (searching) {
                    setState(() {
                      searching = false;
                      searchResults = [];
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b'],
                  userAgentPackageName: 'com.tal3a.app',
                  maxZoom: 19,
                ),
                if (routePoints.isNotEmpty && showRoute)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 12.w,
                        color: AppColors.primaryBlue,
                        borderStrokeWidth: 4.w,
                        borderColor: AppColors.white,
                      ),
                    ],
                  ),
                MarkerLayer(markers: markers),
              ],
            ),

            // Loading Indicator for Route
            if (isLoadingRoute)
              Positioned(
                top: 200.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 48.w,
                      vertical: 32.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20.r,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 48.w,
                          height: 48.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 6.w,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        SizedBox(width: 32.w),
                        Text(
                          'Finding route...',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Search Bar
            Positioned(
              top: 120.h,
              left: 32.w,
              right: 32.w,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => searching = true);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 40.r,
                            offset: Offset(0, 12.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: AppColors.placeholderColor,
                            size: 48.sp,
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: searching
                                ? TextField(
                              controller: searchController,
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              style: TextStyle(fontSize: 32.sp),
                              decoration: InputDecoration(
                                hintText: 'Search place or address',
                                hintStyle: TextStyle(fontSize: 32.sp),
                                border: InputBorder.none,
                                isCollapsed: true,
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    size: 48.sp,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {
                                      searchResults = [];
                                      isLoadingSearch = false;
                                    });
                                  },
                                )
                                    : null,
                              ),
                              onChanged: _searchLocation,
                              onSubmitted: (value) {
                                setState(() => searching = false);
                              },
                            )
                                : Text(
                              'Search for a place',
                              style: TextStyle(
                                color: AppColors.placeholderColor,
                                fontSize: 32.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoadingSearch)
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12.r,
                          ),
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 48.w,
                          height: 48.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 6.w,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (searchResults.isNotEmpty && !isLoadingSearch)
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      constraints: BoxConstraints(maxHeight: 800.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12.r,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1.h,
                          indent: 28.w,
                          endIndent: 28.w,
                        ),
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 28.w,
                              vertical: 16.h,
                            ),
                            leading: Icon(
                              Icons.location_on,
                              color: AppColors.primaryBlue,
                              size: 48.sp,
                            ),
                            title: Text(
                              result['name'],
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              final lat = result['lat'] as double;
                              final lon = result['lon'] as double;
                              _mapController.move(
                                LatLng(lat, lon),
                                _defaultZoom,
                              );
                              _addDestination(LatLng(lat, lon));
                              setState(() {
                                searching = false;
                                searchResults = [];
                                searchController.text = result['name'];
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Floating Action Buttons
            Positioned(
              right: 32.w,
              top: 540.h,
              child: Column(
                children: [
                  Semantics(
                    label: 'Center map on current location',
                    button: true,
                    child: _floatingButton(
                      onTap: _moveToCurrent,
                      icon: Icons.my_location,
                      tooltip: 'My Location',
                    ),
                  ),
                  SizedBox(height: 24.h),
                  if (routePoints.isNotEmpty)
                    Semantics(
                      label: showRoute ? 'Hide route' : 'Show route',
                      button: true,
                      child: _floatingButton(
                        onTap: _toggleRoute,
                        icon: showRoute
                            ? Icons.visibility_off
                            : Icons.visibility,
                        tooltip: showRoute ? 'Hide Route' : 'Show Route',
                      ),
                    ),
                  if (markers.any((m) => m.key == const ValueKey('destination')))
                    SizedBox(height: 24.h),
                  if (markers.any((m) => m.key == const ValueKey('destination')))
                    Semantics(
                      label: 'Clear destination',
                      button: true,
                      child: _floatingButton(
                        onTap: _clearDestination,
                        icon: Icons.clear,
                        tooltip: 'Clear Destination',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingButton({
    required VoidCallback onTap,
    required IconData icon,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 104.w,
          height: 104.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 28.r,
                offset: Offset(0, 16.h),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 52.sp,
          ),
        ),
      ),
    );
  }
}