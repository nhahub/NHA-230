import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/core/core.dart';
import '../service/location_service.dart';
import '../service/route_service.dart';
import '../widget/map_widget.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController searchController = TextEditingController();

  GoogleMapController? _mapController;
  Position? currentLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<Map<String, dynamic>> searchResults = [];

  bool showRoute = true;
  bool searching = false;
  bool isLoadingRoute = false;
  bool isLoadingSearch = false;
  bool showRouteInfo = false;

  double? routeDistance;
  double? routeDuration;

  late LocationService _locationService;
  late RouteService _routeService;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(31.2001, 29.9187),
    zoom: 15.0,
  );

  @override
  void initState() {
    super.initState();

    _routeService = RouteService(
      setIsLoadingRoute: (loading) => setState(() => isLoadingRoute = loading),
      setPolylines: (newPolylines) => setState(() => polylines = newPolylines),
      setShowRoute: (show) => setState(() => showRoute = show),
      setRouteInfo: (distance, duration) => setState(() {
        routeDistance = distance;
        routeDuration = duration;
      }),
      showSnackBar: _showSnackBar,
    );


    _locationService = LocationService(
      onLocationUpdate: (position) => setState(() => currentLocation = position),
      showSnackBar: _showSnackBar,
      updateCurrentMarker: _updateCurrentMarker,
    );

    _initLocation();
  }

  Future<void> _initLocation() async {
    await _locationService.initLocation();
  }

  void _updateCurrentMarker(Position position) {
    markers.removeWhere((marker) => marker.markerId == const MarkerId('current'));

    markers.add(
      Marker(
        markerId: const MarkerId('current'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );
  }

  void _addDestination(LatLng point) {
    markers.removeWhere((marker) => marker.markerId == const MarkerId('destination'));

    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: point,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );

    setState(() {
      showRouteInfo = true;
    });

    if (currentLocation != null) {
      _routeService.fetchRoute(
        LatLng(currentLocation!.latitude, currentLocation!.longitude),
        point,
      );
    }
  }



  void _moveToCurrentLocation() {
    if (currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentLocation!.latitude, currentLocation!.longitude),
        ),
      );
    }
  }

  void _toggleRoute() {
    setState(() {
      showRoute = !showRoute;
      if (!showRoute) {
        polylines = {};
      } else if (markers.any((m) => m.markerId == const MarkerId('destination')) &&
          currentLocation != null) {
        final destinationMarker = markers.firstWhere(
                (m) => m.markerId == const MarkerId('destination')
        );
        _routeService.fetchRoute(
          LatLng(currentLocation!.latitude, currentLocation!.longitude),
          destinationMarker.position,
        );
      }
    });
  }

  void _clearDestination() {
    setState(() {
      markers.removeWhere((m) => m.markerId == const MarkerId('destination'));
      polylines = {};
      showRoute = false;
      routeDistance = null;
      routeDuration = null;
      showRouteInfo = false;
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
  void dispose() {
    _mapController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
            GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              initialCameraPosition: _initialCameraPosition,
              markers: markers,
              polylines: showRoute ? polylines : {},
              onTap: (latlng) {
                _addDestination(latlng);
                if (searching) {
                  setState(() {
                    searching = false;
                    searchResults = [];
                  });
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
            ),

            // Loading Indicator for Route
            if (isLoadingRoute)
              MapWidgets.buildRouteLoadingIndicator(context),


            // Route Info Card
            if (showRouteInfo && routeDistance != null && routeDuration != null && showRoute)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: MapWidgets.buildRouteInfoCard(
                  context,
                  distance: routeDistance!,
                  duration: routeDuration!,
                ),
              ),

            // Floating Action Buttons
            Positioned(
              right: AppSizes.width32,
              top: AppSizes.height540,
              child: Column(
                children: [
                  Semantics(
                    label: localizations.centerMap,
                    button: true,
                    child: MapWidgets.buildFloatingButton(
                      context: context,
                      onTap: _moveToCurrentLocation,
                      icon: Icons.my_location,
                      tooltip: localizations.myLocation,
                    ),
                  ),
                  SizedBox(height: AppSizes.height24),
                  if (polylines.isNotEmpty)
                    Semantics(
                      label: showRoute ? localizations.hideRoute : localizations.showRoute,
                      button: true,
                      child: MapWidgets.buildFloatingButton(
                        onTap: _toggleRoute,
                        icon: showRoute
                            ? Icons.visibility_off
                            : Icons.visibility,
                        tooltip: showRoute ? localizations.hideRoute : localizations.showRoute,
                        context: context,
                      ),
                    ),
                  if (markers.any((m) => m.markerId == const MarkerId('destination')))
                    SizedBox(height: AppSizes.height24),
                  if (markers.any((m) => m.markerId == const MarkerId('destination')))
                    Semantics(
                      label: localizations.clearDestination,
                      button: true,
                      child: MapWidgets.buildFloatingButton(
                        context: context,
                        onTap: _clearDestination,
                        icon: Icons.clear,
                        tooltip: localizations.clearDestination,
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
}