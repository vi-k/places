import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';

class MyThemeData {
  const MyThemeData({
    required this.appThemeData,
    required this.cardSignaturesTextStyle,
    required this.standartButtonTextStyle,
    required this.flatButtonTextStyle,
    required this.flatButtonInactiveTextStyle,
    required this.tabSwitchActiveColor,
    required this.tabSwitchActiveTextStyle,
    required this.tabSwitchInactiveColor,
    required this.tabSwitchInactiveTextStyle,
  });

  final ThemeData appThemeData;

  final TextStyle cardSignaturesTextStyle;

  final TextStyle standartButtonTextStyle;
  final TextStyle flatButtonTextStyle;
  final TextStyle flatButtonInactiveTextStyle;

  final Color tabSwitchActiveColor;
  final TextStyle tabSwitchActiveTextStyle;
  final Color tabSwitchInactiveColor;
  final TextStyle tabSwitchInactiveTextStyle;
}

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
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16), // не использую BorderRadius.circular ради const
    ),
  ),
  elevation: 0,
);

final myLightTheme = MyThemeData(
  appThemeData: ThemeData(
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    primarySwatch: buttonColor,
    // primaryColor: primaryColor,
    backgroundColor: primaryColorLightest,
    scaffoldBackgroundColor: primaryColorLightest,
    buttonTheme: _baseButtonTheme.copyWith(buttonColor: buttonColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryColorLightest,
      selectedItemColor: primaryColor,
      unselectedItemColor: primaryColor,
    ),
    cardTheme: _baseCardTheme.copyWith(color: primaryColorLighter),
    primaryTextTheme: TextTheme(
      headline1: textBold.copyWith(fontSize: 32, color: primaryColor),
      headline2: textBold.copyWith(fontSize: 24, color: primaryColor),
      headline3: textBold.copyWith(fontSize: 18, color: primaryColor),
      headline6: textMiddle.copyWith(fontSize: 16, color: primaryColor),
      bodyText1: textBold.copyWith(color: primaryColor),
      bodyText2: textRegular.copyWith(color: primaryColor),
    ),
    textTheme: TextTheme(
      headline6: textMiddle.copyWith(fontSize: 16, color: primaryColorLight),
      bodyText1: textBold.copyWith(color: primaryColorLight),
      bodyText2: textRegular.copyWith(color: primaryColorLight),
    ),
  ),
  cardSignaturesTextStyle: textBold.copyWith(color: primaryColorLightest),
  standartButtonTextStyle: textBold.copyWith(color: primaryColorLightest),
  flatButtonTextStyle: textRegular.copyWith(color: primaryColor),
  flatButtonInactiveTextStyle:
      textRegular.copyWith(color: primaryColorLightInactive),
  tabSwitchActiveColor: primaryColor,
  tabSwitchActiveTextStyle: textBold.copyWith(color: primaryColorLightest),
  tabSwitchInactiveColor: primaryColorLighter,
  tabSwitchInactiveTextStyle:
      textBold.copyWith(color: primaryColorLightInactive),
);

final myDarkTheme = MyThemeData(
  appThemeData: ThemeData(
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    primarySwatch: buttonColor,
    // primaryColor: primaryColorLightest,
    backgroundColor: primaryColorDarker,
    scaffoldBackgroundColor: primaryColorDarker,
    buttonTheme: _baseButtonTheme.copyWith(buttonColor: buttonColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primaryColorDarker,
      selectedItemColor: primaryColorLightest,
      unselectedItemColor: primaryColorLightest,
    ),
    cardTheme: _baseCardTheme.copyWith(color: primaryColorDarkest),
    primaryTextTheme: TextTheme(
      headline1: textBold.copyWith(fontSize: 32, color: primaryColorLightest),
      headline2: textBold.copyWith(fontSize: 24, color: primaryColorLightest),
      headline3: textBold.copyWith(fontSize: 18, color: primaryColorLightest),
      headline6: textMiddle.copyWith(fontSize: 16, color: primaryColorLightest),
      bodyText1: textBold.copyWith(color: primaryColorLightest),
      bodyText2: textRegular.copyWith(color: primaryColorLightest),
    ),
    textTheme: TextTheme(
      headline6: textMiddle.copyWith(fontSize: 16, color: primaryColorLight),
      bodyText1: textBold.copyWith(color: primaryColorLight),
      bodyText2: textRegular.copyWith(color: primaryColorLight),
    ),
  ),
  cardSignaturesTextStyle: textBold.copyWith(color: primaryColorLightest),
  standartButtonTextStyle: textBold.copyWith(color: primaryColorLightest),
  flatButtonTextStyle: textRegular.copyWith(color: primaryColorLightest),
  flatButtonInactiveTextStyle:
      textRegular.copyWith(color: primaryColorLightInactive),
  tabSwitchActiveColor: primaryColorLightest,
  tabSwitchActiveTextStyle: textBold.copyWith(color: primaryColor),
  tabSwitchInactiveColor: primaryColorDarkest,
  tabSwitchInactiveTextStyle: textBold.copyWith(color: primaryColorLight),
);
