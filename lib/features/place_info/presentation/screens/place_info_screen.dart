import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import '../widgets/place_image_widget.dart';
import '../widgets/place_details_card.dart';
import '../widgets/branches_widget.dart';
import '../widgets/social_media_button.dart';

class PlaceInfoScreen extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const PlaceInfoScreen({super.key, required this.placeData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Stack(
        children: [
          /// IMAGE
          PlaceImageWidget(placeData: placeData),

          /// BACK BUTTON
          Positioned(
            top: AppSizes.height40,
            left: AppSizes.width24,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.primaryBlue),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          /// CONTENT
          Positioned.fill(
            top: AppSizes.height520,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PlaceDetailsCard(placeData: placeData),
                  SizedBox(height: AppSizes.height24),
                  BranchesWidget(branchesData: placeData['Address']),
                  SizedBox(height: AppSizes.height24),
                  SocialMediaButton(url: placeData['Social Media Links']),
                  SizedBox(height: AppSizes.height40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
