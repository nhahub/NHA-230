<<<<<<< HEAD:lib/Constants/Themes/light_theme.dart
import 'package:final_project/Constants/app_colors.dart';
import 'package:final_project/Utils/responsive.dart';
=======
>>>>>>> master:lib/core/themes/light_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splash_screen/core/constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor:AppColors.offWhite,
      iconTheme: IconThemeData(
        color: AppColors.primaryBlue
      ),
      textTheme: TextTheme( 
        titleSmall: GoogleFonts.montserrat(
            fontSize: Responsive(context).fontSize(35),
            fontWeight: FontWeight.bold,
            color: AppColors.placeholderColor,
          ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 50.sp,
          fontWeight: FontWeight.bold,
<<<<<<< HEAD:lib/Constants/Themes/light_theme.dart
          color: AppColors.white,
        ), 
=======
          color: white,
        ),
        titleSmall: GoogleFonts.montserrat(
          fontSize: 35.sp,
          fontWeight: FontWeight.bold,
          color: placeholderColor,
        ),titleLarge: GoogleFonts.montserrat(
          fontSize: 80.sp,
          fontWeight: FontWeight.w900,
        color: white,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 40.sp,
          fontWeight: FontWeight.w400,
          color: white,
        ),
>>>>>>> master:lib/core/themes/light_theme.dart
        bodySmall: GoogleFonts.montserrat(
          fontSize: 30.sp,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(40),
          fontWeight: FontWeight.w400,
          color: AppColors.white,
      ),
      bodyLarge: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(30),
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ),   ///*used for textformfields
        displayLarge: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(47),
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),  //*used for buttons 
          displayMedium: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(45),
          fontWeight: FontWeight.w400,
          color: AppColors.primaryBlue,
        ),  //*used in authenitcation screens
        displaySmall: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(45),
          fontWeight: FontWeight.bold,
          color: AppColors.primaryBlue,
        ), //*used in authenitcation screens
      ),
      inputDecorationTheme: InputDecorationThemeData(
<<<<<<< HEAD:lib/Constants/Themes/light_theme.dart
        hintStyle: TextStyle(
          color: AppColors.placeholderColor,
          fontSize: Responsive(context).fontSize(40),
        ),
=======
        hintStyle: TextStyle(color: placeholderColor, fontSize: 40.sp),
>>>>>>> master:lib/core/themes/light_theme.dart
        filled: true,
        fillColor:AppColors. white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 8.w),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
<<<<<<< HEAD:lib/Constants/Themes/light_theme.dart
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.placeholderColor,
        selectedLabelStyle: TextStyle(
          fontSize: Responsive(context).fontSize(40),
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: Responsive(context).fontSize(40),
        ),
=======
        selectedItemColor: primaryBlue,
        unselectedItemColor: placeholderColor,
        selectedLabelStyle: TextStyle(fontSize: 40.sp),
        unselectedLabelStyle: TextStyle(fontSize: 40.sp),
>>>>>>> master:lib/core/themes/light_theme.dart
      ),
    );
  }
}
