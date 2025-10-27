import 'package:flutter/material.dart';
import 'package:tal3a/core/core.dart';

class MapWidgets {
  static Widget buildCurrentLocationMarker(BuildContext context) {
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

  static Widget buildDestinationPin(BuildContext context) {
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

  static Widget buildFloatingButton({
    required BuildContext context,
    required VoidCallback onTap,
    required IconData icon,
    String? tooltip,
  }) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: AppSizes.width104,
          height: AppSizes.height104,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.radius28),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: AppSizes.radius28,
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

  static Widget buildRouteLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
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
            color: theme.scaffoldBackgroundColor,
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
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated widget for displaying route information at bottom
  static Widget buildRouteInfoCard(
      BuildContext context, {
        required double distance,
        required double duration,
      }) {
    final theme = Theme.of(context);

    // Convert meters to kilometers
    final distanceInKm = distance / 1000;

    // Convert seconds to minutes
    final durationInMinutes = (duration / 60).ceil();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.pd24h,
        vertical: AppSizes.pd20v,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radius20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: AppSizes.radius16,
            offset: Offset(0, AppSizes.height8),
          ),
        ],
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            context,
            icon: Icons.horizontal_distribute_sharp,
            value: '${distanceInKm.toStringAsFixed(1)} km',
          ),
          _buildInfoItem(
            context,
            icon: Icons.access_time,
            value: '$durationInMinutes minutes',
          ),
          _buildInfoItem(
            context,
            icon: Icons.directions_car,
            value: '${_calculateAverageSpeed(distanceInKm, durationInMinutes)} km/h',
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoItem(
      BuildContext context, {
        required IconData icon,
        required String value,
      }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.primaryBlue,
          size: AppSizes.radius80,
        ),
        SizedBox(height: AppSizes.height8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(height: AppSizes.height4),
      ],
    );
  }

  static String _calculateAverageSpeed(double distanceInKm, int durationInMinutes) {
    if (durationInMinutes == 0) return '0';
    final hours = durationInMinutes / 60;
    final averageSpeed = distanceInKm / hours;
    return averageSpeed.toStringAsFixed(1);
  }
}