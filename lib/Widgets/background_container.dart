import 'package:flutter/material.dart';
import 'package:final_project/Constants/assets.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppImages.homeScreenBackground,
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}
