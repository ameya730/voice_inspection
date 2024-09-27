import 'package:flutter/material.dart';
import 'package:voice_poc/services/themes/constants/colors.dart';

ThemeData baseTheme = ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      color: Colors.black87,
      fontWeight: FontWeight.w400,
    ),
  ),
  iconTheme: const IconThemeData(size: 16, color: Colors.black),
  primaryColor: Colors.blue.shade800,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.black.withOpacity(0.65),
  drawerTheme: DrawerThemeData(
    elevation: 2,
    shadowColor: Colors.white,
    backgroundColor: Colors.white.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary.color,
    titleTextStyle: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: true,
    shadowColor: Colors.transparent,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(
      color: AppColors.hintColor.color.withOpacity(0.75),
      fontSize: 14,
    ),
    labelStyle: TextStyle(
      color: AppColors.black.color,
      fontSize: 12,
    ),
    border: InputBorder.none,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    alignLabelWithHint: true,
    floatingLabelAlignment: FloatingLabelAlignment.start,
  ),
);
