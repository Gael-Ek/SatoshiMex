import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:satoshimex/core/config/constants/app_colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,

    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,

    scaffoldBackgroundColor: AppColors.blueDark,

    //Tema para los appbars//
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    //Tema para el bottom navigation bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.blueDark,
      selectedItemColor: AppColors.primaryAmber,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.lexend(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: GoogleFonts.lexend(fontSize: 14),
      type: BottomNavigationBarType.fixed,
    ),
  );
}
