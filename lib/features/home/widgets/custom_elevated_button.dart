import 'package:final_project/Utils/responsive.dart';
import 'package:flutter/material.dart';

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
    //final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
        ),
        fixedSize: Size(Responsive(context).screenWidth * 0.95 ,Responsive(context).height(100)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
