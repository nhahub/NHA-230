import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_colors..dart';
import 'package:tal3a/core/constants/app_sizes.dart';
import 'package:tal3a/core/constants/app_assets.dart';
import '../widgets/place_image_widget.dart';
import '../widgets/place_details_widget.dart';
import '../widgets/branches_widget.dart';
import '../widgets/social_media_button.dart';

class PlaceInfoScreen extends StatelessWidget {
  final Map<String, dynamic> placeData;

  const PlaceInfoScreen({super.key, required this.placeData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: theme.scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width40,
            vertical: AppSizes.height16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryBlue,
                  size: AppSizes.width70,
                ),
              ),
              Expanded(
                child: Image.asset(
                  AppAssets.appbarIconLightTheme,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: AppSizes.width90),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (placeData['Image'] != null)
            PlaceImageWidget(imageUrl: placeData['Image']),
          Transform.translate(
            offset: Offset(0, -AppSizes.height120),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.pd32h),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.pd70h),
                  topRight: Radius.circular(AppSizes.pd70h),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlaceDetailsWidget(placeData: placeData),
                  SizedBox(height: AppSizes.height24),
                  Divider(
                    // color: Colors.black,
                    thickness: 1.5,
                    endIndent: AppSizes.width100,
                    indent: AppSizes.width100,
                  ),
                  SizedBox(height: AppSizes.height24),
                  BranchesWidget(branchesData: placeData['Address']),
                  SizedBox(height: AppSizes.height24),
                  SocialMediaButton(url: placeData['Social Media Links']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}