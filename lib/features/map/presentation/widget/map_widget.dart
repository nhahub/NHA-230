import 'package:flutter/material.dart';
import 'package:tal3a/core/core.dart';

class MapWidgets {
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
                color: AppColors.darkGrey,
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

  static Widget buildSearchLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: AppSizes.height8),
      padding: EdgeInsets.all(AppSizes.pd32a),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radius20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGrey,
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
    );
  }

  static Widget buildSearchResults(
      BuildContext context, {
        required List<Map<String, dynamic>> searchResults,
        required Function(Map<String, dynamic>) onLocationSelected,
      }) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: AppSizes.height8),
      constraints: BoxConstraints(maxHeight: AppSizes.height800),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radius20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGrey,
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
            subtitle: result['address'] != null ? Text(
              result['address'],
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ) : null,
            onTap: () => onLocationSelected(result),
          );
        },
      ),
    );
  }

  static Widget buildRouteInfoCard(
      BuildContext context, {
        required double distance,
        required double duration,
      }) {
    final theme = Theme.of(context);


    final distanceInKm = distance / 1000;

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
            color: AppColors.darkGrey,
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
            icon: Icons.route,
            value: '${distanceInKm.toStringAsFixed(1)} km',
          ),
          _buildInfoItem(
            context,
            icon: Icons.access_time,
            value: '$durationInMinutes min',
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