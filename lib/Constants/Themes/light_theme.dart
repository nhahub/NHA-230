import 'package:final_project/Constants/app_colors.dart';
import 'package:final_project/Utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          fontSize: Responsive(context).fontSize(50),
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ), 
        bodySmall: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(30),
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
        hintStyle: TextStyle(
          color: AppColors.placeholderColor,
          fontSize: Responsive(context).fontSize(40),
        ),
        filled: true,
        fillColor:AppColors. white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: Responsive(context).width(8),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.placeholderColor,
        selectedLabelStyle: TextStyle(
          fontSize: Responsive(context).fontSize(40),
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: Responsive(context).fontSize(40),
        ),
      ),

    );
  }
}
