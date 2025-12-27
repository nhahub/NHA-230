import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';

class PlaceImageWidget extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const PlaceImageWidget({super.key, required this.placeData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          placeData['Image'],
          width: double.infinity,
          height: AppSizes.height600,
          fit: BoxFit.cover,
        ),

        /// GRADIENT
        Container(
          height: AppSizes.height600,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
        ),

        /// TITLE + RATING
        Positioned(
          bottom: AppSizes.height40,
          left: AppSizes.width24,
          right: AppSizes.width24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                placeData['Name'],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: AppSizes.height8),
              if (placeData['Rating'] != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star,
                          color: AppColors.yellow, size: 18),
                      SizedBox(width: 4),
                      Text(
                        placeData['Rating'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
