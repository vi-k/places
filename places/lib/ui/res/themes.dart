import 'package:flutter/material.dart';
import 'package:places/ui/res/text_styles.dart';

import 'colors.dart';
import 'const.dart';

const _baseButtonTheme = ButtonThemeData(
  height: 48,
  textTheme: ButtonTextTheme.normal,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  ),
);

const _baseCardTheme = CardTheme(
  clipBehavior: Clip.antiAlias,
  color: darkCardBackground,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      // не использую BorderRadius.circular ради const
      Radius.circular(16),
    ),
  ),
  elevation: 0,
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: lightPrimaryColor,
  backgroundColor: lightBackgroundColor,
  scaffoldBackgroundColor: lightBackgroundColor,
  buttonTheme: _baseButtonTheme.copyWith(
    buttonColor: lightPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: lightBackgroundColor,
    selectedItemColor: lightTextPrimaryColor,
    unselectedItemColor: lightTextPrimaryColor,
  ),
  cardTheme: _baseCardTheme.copyWith(
    color: lightCardBackground,
  ),
  fontFamily: 'Roboto',
  primaryTextTheme: TextTheme(
    headline1: textBold32.copyWith(color: lightTextPrimaryColor),
    headline2: textBold24.copyWith(color: lightTextPrimaryColor),
    headline3: textBold18.copyWith(color: lightTextPrimaryColor),
    headline6: textMiddle16.copyWith(color: lightTextPrimaryColor),
    bodyText1: textBold.copyWith(color: lightTextPrimaryColor),
    bodyText2: textRegular.copyWith(color: lightTextPrimaryColor),
  ),
  textTheme: TextTheme(
    headline6: textMiddle16.copyWith(color: lightTextSecondaryColor),
    bodyText1: textBold.copyWith(color: lightTextSecondaryColor),
    bodyText2: textRegular.copyWith(color: lightTextSecondaryColor),
  ),
  accentTextTheme: TextTheme(
    headline4: textBold.copyWith(color: lightTextButtonColor), // Standart Button
    headline5: textBold.copyWith(color: lightTextButtonColor), // Small Button Active
    headline6: textBold.copyWith(color: lightTextButtonColor), // Small Button Inactive
    bodyText1: textBold.copyWith(color: cardSignaturesColor),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: darkPrimaryColor,
  backgroundColor: darkBackgroundColor,
  scaffoldBackgroundColor: darkBackgroundColor,
  buttonTheme: _baseButtonTheme.copyWith(
    buttonColor: darkPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: darkBackgroundColor,
    selectedItemColor: darkTextPrimaryColor,
    unselectedItemColor: darkTextPrimaryColor,
  ),
  cardTheme: _baseCardTheme.copyWith(
    color: darkCardBackground,
  ),
  fontFamily: 'Roboto',
  primaryTextTheme: TextTheme(
    headline1: textBold32.copyWith(color: darkTextPrimaryColor),
    headline2: textBold24.copyWith(color: darkTextPrimaryColor),
    headline3: textBold18.copyWith(color: darkTextPrimaryColor),
    headline6: textMiddle16.copyWith(color: darkTextPrimaryColor),
    bodyText1: textBold.copyWith(color: darkTextPrimaryColor),
    bodyText2: textRegular.copyWith(color: darkTextPrimaryColor),
  ),
  textTheme: TextTheme(
    headline6: textMiddle16.copyWith(color: darkTextSecondaryColor),
    bodyText1: textBold.copyWith(color: darkTextSecondaryColor),
    bodyText2: textRegular.copyWith(color: darkTextSecondaryColor),
  ),
  accentTextTheme: TextTheme(
    headline4: textBold.copyWith(color: darkTextButtonColor), // Standart Button
    headline5: textBold.copyWith(color: darkTextButtonColor), // Small Button Active
    headline6: textBold.copyWith(color: darkTextButtonColor), // Small Button Inactive
    bodyText1: textBold.copyWith(color: cardSignaturesColor),
  ),
);
