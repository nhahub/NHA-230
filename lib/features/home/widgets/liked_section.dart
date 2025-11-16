import 'package:flutter/material.dart';
import 'package:tal3a/core/core.dart';

class PromotionSlider extends StatelessWidget {
  final String imagePath;

  const PromotionSlider({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:AppSizes.height480,
      child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius40),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ));
        }
  }
