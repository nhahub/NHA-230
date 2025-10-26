import 'package:flutter/material.dart';
import 'package:tal3a/core/core.dart';

class PromotionSlider extends StatelessWidget {
  final List<String> imagePaths;

  const PromotionSlider({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:AppSizes.height480,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        padding:  EdgeInsets.symmetric(horizontal:AppSizes.pd16h ),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radius40),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imagePaths[index],
              fit: BoxFit.cover,
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) =>SizedBox(width: AppSizes.width40),
      ),
    );
  }
}
