import 'package:flutter/material.dart';
import 'package:tal3a/core/core.dart';

class LikedSection extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTapFunction;

  const LikedSection({super.key, required this.imagePath, required this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:AppSizes.height480,
      child: GestureDetector(
        onTap: onTapFunction,
        child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius40),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
      ));
        }
  }
