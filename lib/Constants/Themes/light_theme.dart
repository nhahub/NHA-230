import 'package:final_project/Constants/colors.dart';
import 'package:final_project/Utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
        titleMedium: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(50),
          fontWeight: FontWeight.bold,
          color: white,
        ),
          titleSmall: GoogleFonts.montserrat(
            fontSize: Responsive(context).fontSize(35),
            fontWeight: FontWeight.bold,
            color: placeholderColor,
          ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(40),
          fontWeight: FontWeight.w400,
          color: white,
      ),
        bodySmall: GoogleFonts.montserrat(
          fontSize: Responsive(context).fontSize(30),
          fontWeight: FontWeight.w400,
        ),
      ),

      inputDecorationTheme: InputDecorationThemeData(
        hintStyle: TextStyle(
          color: placeholderColor,
          fontSize: Responsive(context).fontSize(40),
        ),
        filled: true,
        fillColor: white,
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
        selectedItemColor: primaryBlue,
        unselectedItemColor: placeholderColor,
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
