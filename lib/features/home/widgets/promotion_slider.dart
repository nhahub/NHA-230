import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromotionSlider extends StatelessWidget {
  final List<String> imagePaths;

  const PromotionSlider({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:480.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        padding:  EdgeInsets.symmetric(horizontal: 38.w),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imagePaths[index],
              fit: BoxFit.cover,
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) =>SizedBox(width: 40.w),
      ),
    );
  }
}
