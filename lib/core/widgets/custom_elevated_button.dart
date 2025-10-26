import 'package:flutter/material.dart';
import 'package:tal3a/core/constants/app_sizes.dart';


class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.backgroundColor,
  });
  final Widget child;
  final Color backgroundColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
        ),
        fixedSize: Size(screenWidth * 0.95 ,AppSizes.height100),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
