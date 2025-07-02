import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final _buttonStyle = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.secondaryColor));

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Poppins",
    colorSchemeSeed: AppColors.primaryColor,
    buttonTheme: ButtonThemeData(buttonColor: AppColors.secondaryColor),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(AppColors.secondaryColor))),
    filledButtonTheme: FilledButtonThemeData(style: _buttonStyle),
    useMaterial3: true,
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Poppins",
    colorSchemeSeed: AppColors.primaryColor,
    useMaterial3: true,
  );

  static BoxDecoration backgroundColorTheme = BoxDecoration(
      gradient: LinearGradient(
    colors: [
      AppColors.secondaryColor,
      AppColors.primaryColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ));

  static BoxDecoration backgroundColor2Theme = BoxDecoration(
      gradient: LinearGradient(
    colors: [
      AppColors.primaryColor,
      AppColors.secondaryColor,
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  ));

  static double borderRadius = 14;
}
