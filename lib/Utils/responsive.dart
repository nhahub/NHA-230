import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  final double screenWidth;
  final double screenHeight;

  Responsive(this.context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

  static const double baseWidth = 1080;
  static const double baseHeight = 1920;

  double width(double value) {
    return (value / baseWidth) * screenWidth;
  }

  double height(double value) {
    return (value / baseHeight) * screenHeight;
  }

  double fontSize(double value) {
    return (value / baseWidth) * screenWidth;
  }
}
