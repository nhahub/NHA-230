import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tal3a/core/constants/app_colors..dart';

class DarkTheme {
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.primaryBlack,
      iconTheme: IconThemeData(color: AppColors.offWhite),
      appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryBlue),
      textTheme: TextTheme(
        titleSmall: GoogleFonts.montserrat(
          fontSize: 35.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.offWhite,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 50.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.offWhite,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 80.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.offWhite,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 40.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.offWhite,
        ),
        bodySmall: GoogleFonts.montserrat(
          fontSize: 30.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.offWhite,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
        displayLarge: GoogleFonts.montserrat(
          fontSize: 47.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.offWhite,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 45.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryBlue,
        ),
        displaySmall: GoogleFonts.montserrat(
          fontSize: 45.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),
        headlineLarge: GoogleFonts.montserrat(
          fontSize: 70.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.offWhite,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 60.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.offWhite,
        ),
        headlineSmall: GoogleFonts.montserrat(
          fontSize: 50.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.offWhite,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: AppColors.placeholderColor,
          fontSize: 40.sp,
        ),
        filled: true,
        fillColor: AppColors.primaryBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 8.w),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.placeholderColor,
        selectedLabelStyle: TextStyle(fontSize: 40.sp),
        unselectedLabelStyle: TextStyle(fontSize: 40.sp),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.yellow; // when ON
          }
          return AppColors.placeholderColor; // when OFF
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.offWhite; // when ON
          }
          return AppColors.placeholderColor.withAlpha(50);
        }),
      ),
      cardColor: AppColors.darkGrey,
    );
  }
}
