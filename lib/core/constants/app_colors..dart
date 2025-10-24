import 'package:flutter/material.dart';

class AppColors {
  static final Color primaryBlue = Color(0xff4e75ff);
  static final Color secondaryBlue = Color(0xff2e93ce);
static final Color middleBlue = Color(0xff6fb9ff);
  static final LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, middleBlue, secondaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight, 
  );
  static final Color placeholderColor = Color(0xff7f7f7f);
  static final Color white = Colors.white;
  static final Color offWhite = Color(0xfff4f4f4);
  static final Color yellow = Color(0XFFFAEA00);
  static final Color black = Colors.black;
  static final Color red = Colors.red;
  static final Color shadowColor = Colors.grey.withValues(alpha: 0.15);
}
