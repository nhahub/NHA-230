import 'package:flutter/material.dart';
import 'package:final_project/core/constants/app_assets.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            homeScreenBackground,
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}
