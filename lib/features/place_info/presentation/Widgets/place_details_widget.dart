import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'info_item_widget.dart';

class PlaceDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const PlaceDetailsWidget({super.key, required this.placeData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            placeData['Name'] ?? 'Unnamed Place',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.width64,
            ),
          ),
        ),
        SizedBox(height: AppSizes.height16),
        Divider(
          color: Colors.black,
          thickness: 1.5,
          endIndent: AppSizes.width100,
          indent: AppSizes.width100,
        ),
        SizedBox(height: AppSizes.height16),
        InfoItemWidget(label: "Type", value: placeData['Type']),
        if (placeData['Rating'] != null) ...[
          Row(
            children: [
              Text(
                "Rating: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  fontSize: AppSizes.width56,
                ),
              ),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: AppSizes.width56,
              ),
              SizedBox(width: AppSizes.width8),
              Text(
                placeData['Rating'].toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.width48,
                ),
              ),
            ],
          ),
        ],
        if (placeData['Opening Hours'] != null)
          Row(
            children: [
              Text(
                'Opening Hours: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  fontSize: AppSizes.width56,
                ),
              ),
              Icon(
                Icons.access_time_filled,
                color: Colors.black,
                size: AppSizes.width56,
              ),
              SizedBox(width: AppSizes.width8),
              Expanded(
                child: Text(
                  placeData['Opening Hours'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: AppSizes.width48,
                  ),
                ),
              ),
            ],
          ),
        InfoItemWidget(
          label: "Best Time to Visit",
          value: placeData['Best Time to Visit'],
        ),
      ],
    );
  }
}
