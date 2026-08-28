import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,

    fontFamily: 'Poppins',

    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
    ),
  );
}