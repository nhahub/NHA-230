import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splash_screen/core/constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
        titleMedium: GoogleFonts.montserrat(
          fontSize: 50.sp,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        titleSmall: GoogleFonts.montserrat(
          fontSize: 35.sp,
          fontWeight: FontWeight.bold,
          color: placeholderColor,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 40.sp,
          fontWeight: FontWeight.w400,
          color: white,
        ),
        bodySmall: GoogleFonts.montserrat(
          fontSize: 30.sp,
          fontWeight: FontWeight.w400,
        ),
      ),

      inputDecorationTheme: InputDecorationThemeData(
        hintStyle: TextStyle(color: placeholderColor, fontSize: 40.sp),
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 8.w),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBlue,
        unselectedItemColor: placeholderColor,
        selectedLabelStyle: TextStyle(fontSize: 40.sp),
        unselectedLabelStyle: TextStyle(fontSize: 40.sp),
      ),
    );
  }
}
