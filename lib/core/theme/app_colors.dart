import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color igBlue = Color(0xFF0095F6);
  static const Color igBlack = Color(0xFF000000);
  static const Color igGrey = Color(0xFF8E8E8E);
  static const Color igLightGrey = Color(0xFFDBDBDB);
  static const Color igBackgroundDark = Color(0xFF000000);
  static const Color igSurfaceDark = Color(0xFF121212);
  static const Color igBackgroundLight = Color(0xFFFFFFFF);
  static const Color igRed = Color(0xFFED4956);

  static const LinearGradient storyGradient = LinearGradient(
    colors: [
      Color(0xFFFEDA75),
      Color(0xFFFA7E1E),
      Color(0xFFD62976),
      Color(0xFF962FBF),
      Color(0xFF4F5BD5),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}