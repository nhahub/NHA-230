import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:tal3a/core/core.dart';

import '../constant/map_constants.dart';
import '../service/location_service.dart';
import '../service/route_service.dart';
import '../service/search_service.dart';
import '../widget/map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController searchController = TextEditingController();

  LocationData? currentLocation;
  List<Marker> markers = [];
  List<LatLng> routePoints = [];
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
  late SearchService _searchService;

  @override
  void initState() {
    super.initState();

    _routeService = RouteService(
      setIsLoadingRoute: (loading) => setState(() => isLoadingRoute = loading),
      setRoutePoints: (points) => setState(() => routePoints = points),
      setShowRoute: (show) => setState(() => showRoute = show),
      setRouteInfo: (distance, duration) => setState(() {
        routeDistance = distance;
        routeDuration = duration;
      }),
      showSnackBar: _showSnackBar,
    );

    _searchService = SearchService(
      setSearchResults: (results) => setState(() => searchResults = results),
      setIsLoadingSearch: (loading) => setState(() => isLoadingSearch = loading),
      showSnackBar: _showSnackBar,
    );

    _locationService = LocationService(
      mapController: _mapController,
      onLocationUpdate: (loc) => setState(() => currentLocation = loc),
      showSnackBar: _showSnackBar,
      updateCurrentMarker: _updateCurrentMarker,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _locationService.initLocation();
    });
  }

  @override
  void dispose() {
    _locationService.dispose();
    _searchService.dispose();
    searchController.dispose();
    super.dispose();
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
          child: MapWidgets.buildCurrentLocationMarker(context),
        ),
      );
    }
  }

  void _addDestination(LatLng point) {
    markers.removeWhere((m) => m.key == const ValueKey('destination'));
    markers.add(
      Marker(
        key: const ValueKey('destination'),
        width: AppSizes.width112,
        height: AppSizes.height152,
        point: point,
        child: MapWidgets.buildDestinationPin(context),
      ),
    );
    setState(() {
      showRouteInfo = true;
    });
    _routeService.fetchRoute(currentLocation, point);
  }

  void _searchLocation(String query) {
    _searchService.searchLocation(query, currentLocation);
  }

  void _moveToCurrent() {
    _locationService.moveToCurrentLocation(currentLocation);
  }

  void _toggleRoute() {
    setState(() => showRoute = !showRoute);
  }

  void _clearDestination() {
    setState(() {
      markers.removeWhere((m) => m.key == const ValueKey('destination'));
      routePoints = [];
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(31.2001, 29.9187),
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
                        borderColor: theme.scaffoldBackgroundColor,
                      ),
                    ],
                  ),
                MarkerLayer(markers: markers),
              ],
            ),


            // Loading Indicator for Route
            if (isLoadingRoute)
              MapWidgets.buildRouteLoadingIndicator(context),

            // Search Bar
            Positioned(
              top: AppSizes.height120,
              left: AppSizes.width32,
              right: AppSizes.width32,
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
                        color: theme.scaffoldBackgroundColor,
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
                            size: AppSizes.radius80,
                          ),
                          SizedBox(width: AppSizes.width24),
                          Expanded(
                            child: searching
                                ? TextField(
                              controller: searchController,
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              style: Theme.of(context).textTheme.displayMedium,
                              decoration: InputDecoration(
                                hintText: 'Search place or address',
                                hintStyle: Theme.of(context).textTheme.displayMedium,
                                border: InputBorder.none,
                                isCollapsed: true,
                                suffixIcon:
                                searchController.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    size: AppSizes.radius80,
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
                              style: Theme.of(context).textTheme.displayMedium,
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
                        color: theme.scaffoldBackgroundColor,
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
                        color: theme.scaffoldBackgroundColor,
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
                          height: AppSizes.height1,
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
                              size: AppSizes.radius50,
                            ),
                            title: Text(
                              result['name'],
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              final lat = result['lat'] as double;
                              final lon = result['lon'] as double;
                              _mapController.move(
                                LatLng(lat, lon),
                                MapConstants.defaultZoom,
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
            if (showRouteInfo && routeDistance != null && routeDuration != null && showRoute)
              Positioned(
                bottom: 0,
                left: 0,
                 right:0,
                child: MapWidgets.buildRouteInfoCard(
                  context,
                  distance: routeDistance!,
                  duration: routeDuration!,

                ),
              ),
            Positioned(
              right: AppSizes.width32,
              top: AppSizes.height540,
              child: Column(
                children: [
                  Semantics(
                    label: 'Center map on current location',
                    button: true,
                    child: MapWidgets.buildFloatingButton(
                      context: context,
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
                      child: MapWidgets.buildFloatingButton(
                        onTap: _toggleRoute,
                        icon: showRoute
                            ? Icons.visibility_off
                            : Icons.visibility,
                        tooltip: showRoute ? 'Hide Route' : 'Show Route',
                        context: context,
                      ),
                    ),
                  if (markers.any((m) => m.key == const ValueKey('destination')))
                    SizedBox(height: AppSizes.height24),
                  if (markers.any((m) => m.key == const ValueKey('destination')))
                    Semantics(
                      label: 'Clear destination',
                      button: true,
                      child: MapWidgets.buildFloatingButton(
                        context: context,
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
}