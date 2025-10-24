import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tal3a/core/constants/app_colors..dart';
class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.offWhite,
      iconTheme: IconThemeData(color: AppColors.primaryBlue),
      textTheme: TextTheme(
        titleSmall: GoogleFonts.montserrat(
          fontSize: 35.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.placeholderColor,
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
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),

        ///*used for textformfields
        displayLarge: GoogleFonts.montserrat(
          fontSize: 47.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.offWhite,
        ), //*used for buttons
        displayMedium: GoogleFonts.montserrat(
          fontSize: 45.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryBlue,
        ), //*used in authenitcation screens
        displaySmall: GoogleFonts.montserrat(
          fontSize: 45.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ), //*used in authenitcation screens
        headlineLarge: GoogleFonts.montserrat(
          fontSize: 70.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.offWhite,
        ),//*used for the appbar title  
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 60.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
        headlineSmall: GoogleFonts.montserrat(
          fontSize: 50.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        hintStyle: TextStyle(color: AppColors.placeholderColor, fontSize: 40.sp),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 8.w),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
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
    return AppColors.placeholderColor.withAlpha(3); 
  }),
),

    );
  }
}
