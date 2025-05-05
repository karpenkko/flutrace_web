import 'package:flutter/material.dart';
import 'colors.dart';

class AppThemeData {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    cardColor: AppColors.light.grey,
    primaryColor: AppColors.light.white,
    primaryColorLight: AppColors.light.staticWhite,
    colorScheme: ColorScheme.light(
      primary: AppColors.light.lightWhite,
      secondary: AppColors.light.black,
      tertiary: AppColors.light.staticBlack,
      surface: AppColors.light.blue,
      error: AppColors.light.error,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    cardColor: AppColors.dark.grey,
    primaryColor: AppColors.dark.white,
    primaryColorLight: AppColors.dark.staticWhite,
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.lightWhite,
      secondary: AppColors.dark.black,
      tertiary: AppColors.dark.staticBlack,
      surface: AppColors.dark.blue,
      error: AppColors.light.error,
    ),
  );
}
