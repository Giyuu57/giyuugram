import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.igBackgroundLight,
        primaryColor: AppColors.igBlack,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.igBlue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.igBackgroundLight,
          foregroundColor: AppColors.igBlack,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.igBackgroundLight,
          selectedItemColor: AppColors.igBlack,
          unselectedItemColor: AppColors.igGrey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerColor: AppColors.igLightGrey,
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.igBackgroundDark,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.igBlue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.igBackgroundDark,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.igBackgroundDark,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.igGrey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerColor: const Color(0xFF262626),
        useMaterial3: true,
      );
}
