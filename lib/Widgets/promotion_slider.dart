import 'package:final_project/Utils/responsive.dart';
import 'package:flutter/material.dart';

class PromotionSlider extends StatelessWidget {
  final List<String> imagePaths;

  const PromotionSlider({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive(context).height(400),
      child: ListView.builder(
        itemExtent: Responsive(context).height(750),
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        padding:  EdgeInsets.symmetric(horizontal: Responsive(context).width(40)),
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(right: Responsive(context).height(40)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imagePaths[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
