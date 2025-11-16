import 'package:flutter/material.dart';
import 'package:tal3a/L10n/app_localizations.dart';
import 'package:tal3a/core/core.dart';
import 'info_item_widget.dart';

class PlaceDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const PlaceDetailsWidget({super.key, required this.placeData});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            placeData['Name'] ?? localizations.unnamedPlace,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
            // style: TextStyle(
            //   color: Colors.black,
            //   fontWeight: FontWeight.bold,
            //   fontSize: AppSizes.width64,
            // ),
          ),
        ),
        SizedBox(height: AppSizes.height16),
        Divider(
          thickness: 1.5,
          endIndent: AppSizes.width100,
          indent: AppSizes.width100,
        ),
        SizedBox(height: AppSizes.height16),
        InfoItemWidget(label: localizations.type, value: placeData['Type']),
        if (placeData['Rating'] != null) ...[
          Row(
            children: [
              Text(
                localizations.rating,
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
                style: Theme.of(context).textTheme.titleMedium,
                // style: TextStyle(
                //   color: Colors.black,
                //   fontWeight: FontWeight.bold,
                //   fontSize: AppSizes.width48,
                // ),
              ),
            ],
          ),
        ],
        if (placeData['Opening Hours'] != null)
          Row(
            children: [
              Text(
                localizations.openingHours,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  fontSize: AppSizes.width56,
                ),
              ),
              Icon(
                Icons.access_time_filled,
                size: AppSizes.width56,
              ),
              SizedBox(width: AppSizes.width8),
              Expanded(
                child: Text(
                  placeData['Opening Hours'],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        InfoItemWidget(
          label: localizations.bestTimeToVisit,
          value: placeData['Best Time to Visit'],
        ),
      ],
    );
  }
}
