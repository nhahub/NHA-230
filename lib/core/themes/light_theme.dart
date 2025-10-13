import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tal3a/core/constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: offWhite,
      iconTheme: IconThemeData(color: primaryBlue),
      textTheme: TextTheme(
        titleSmall: GoogleFonts.montserrat(
          fontSize: 35.sp,
          fontWeight: FontWeight.bold,
          color: placeholderColor,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 50.sp,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 80.sp,
          fontWeight: FontWeight.w900,
          color: white,
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
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),

        ///*used for textformfields
        displayLarge: GoogleFonts.montserrat(
          fontSize: 47.sp,
          fontWeight: FontWeight.bold,
          color: white,
        ), //*used for buttons
        displayMedium: GoogleFonts.montserrat(
          fontSize: 45.sp,
          fontWeight: FontWeight.w400,
          color: primaryBlue,
        ), //*used in authenitcation screens
        displaySmall: GoogleFonts.montserrat(
          fontSize: 45.sp,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ), //*used in authenitcation screens
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
