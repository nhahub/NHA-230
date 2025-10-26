import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocation();
    });
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
          width: AppSizes.width112,
          height: AppSizes.height112,
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
        width: AppSizes.width80,
        height: AppSizes.height80,
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
              blurRadius: AppSizes.width16,
            ),
          ],
        ),
        child: Icon(
          Icons.my_location,
          size: AppSizes.radius36,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildDestinationPin() {
    return SizedBox(
      width: AppSizes.width100,
      height: AppSizes.height140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.width72,
            height: AppSizes.height72,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryBlue, width: AppSizes.width4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: AppSizes.radius12,
                ),
              ],
            ),
            child: Icon(
              Icons.place,
              size: AppSizes.radius36,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: AppSizes.height12),
          Transform.rotate(
            angle: 3.1416 / 4,
            child: Container(
              width: AppSizes.width36,
              height: AppSizes.height36,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: AppSizes.radius8,
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
        width: AppSizes.width112,
        height: AppSizes.height152,
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
            borderRadius: BorderRadius.circular(AppSizes.radius20),
          ),
          margin: EdgeInsets.all(AppSizes.pd32a),
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
                initialZoom: 15.0,
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
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.tal3a.app',
                  maxZoom: 19,
                ),
                if (routePoints.isNotEmpty && showRoute)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: AppSizes.width12,
                        color: AppColors.primaryBlue,
                        borderStrokeWidth: AppSizes.width4,
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
                top: AppSizes.height200,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.pd48h,
                      vertical: AppSizes.pd32v,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radius28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: AppSizes.radius20,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: AppSizes.width48,
                          height: AppSizes.height48,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.width6,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.width32),
                        Text(
                          'Finding route...',
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Search Bar
            Positioned(
              top: AppSizes.height120,
              left:AppSizes.width32,
              right:AppSizes.width32,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => searching = true);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.pd28h,
                        vertical: AppSizes.pd20v,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radius28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: AppSizes.radius40,
                            offset: Offset(0, AppSizes.height12),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: AppColors.placeholderColor,
                            size: AppSizes.radius48,
                          ),
                          SizedBox(width: AppSizes.width24),
                          Expanded(
                            child: searching
                                ? TextField(
                              controller: searchController,
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              style: Theme.of(context).textTheme.titleLarge,
                              decoration: InputDecoration(
                                hintText: 'Search place or address',
                                hintStyle:  Theme.of(context).textTheme.titleLarge,
                                border: InputBorder.none,
                                isCollapsed: true,
                                suffixIcon:
                                searchController.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    size: AppSizes.radius48,
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
                              style:  Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoadingSearch)
                    Container(
                      margin: EdgeInsets.only(top: AppSizes.height8),
                      padding: EdgeInsets.all(AppSizes.pd32a),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radius20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: AppSizes.radius12,
                          ),
                        ],
                      ),
                      child: Center(
                        child: SizedBox(
                          width: AppSizes.width48,
                          height: AppSizes.height48,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.width6,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (searchResults.isNotEmpty && !isLoadingSearch)
                    Container(
                      margin: EdgeInsets.only(top: AppSizes.height8),
                      constraints: BoxConstraints(maxHeight: AppSizes.height800),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radius20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: AppSizes.radius12,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        separatorBuilder: (context, index) => Divider(
                          height:AppSizes.height1,
                          indent: AppSizes.width28,
                          endIndent: AppSizes.width28,
                        ),
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSizes.pd28h,
                              vertical: AppSizes.pd16v,
                            ),
                            leading: Icon(
                              Icons.location_on,
                              color: AppColors.primaryBlue,
                              size: AppSizes.radius48,
                            ),
                            title: Text(
                              result['name'],
                              style:  Theme.of(context).textTheme.titleLarge,
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
              right: AppSizes.width32,
              top: AppSizes.height540,
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
                  SizedBox(height: AppSizes.height24),
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
                  if (markers
                      .any((m) => m.key == const ValueKey('destination')))
                    SizedBox(height: AppSizes.height24),
                  if (markers
                      .any((m) => m.key == const ValueKey('destination')))
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
          width: AppSizes.width104,
          height: AppSizes.height104,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radius28),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius:AppSizes.radius28,
                offset: Offset(0, AppSizes.height16),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: AppSizes.radius52,
          ),
        ),
      ),
    );
  }
}