import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'info_item_widget.dart';

class PlaceDetailsCard extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const PlaceDetailsCard({super.key, required this.placeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.width24),
      padding: EdgeInsets.all(AppSizes.pd32h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoItemWidget(
            icon: Icons.category,
            value: placeData['Type'],
          ),
          InfoItemWidget(
            icon: Icons.access_time,
            value: placeData['Opening Hours'],
          ),
          InfoItemWidget(
            icon: Icons.calendar_today,
            value: placeData['Best Time to Visit'],
          ),
        ],
      ),
    );
  }
}
