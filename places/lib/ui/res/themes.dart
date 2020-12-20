import 'package:flutter/material.dart';

/// Собственная тема приложения, т.к. средств обычной ThemeData в нашем случае
/// недостаточно.
///
/// Свой вариант у Flutter team:
/// https://github.com/flutter/gallery/tree/master/lib/themes
class MyThemeData {
  /// Константы.
  static const smallButtonRadius = 40.0;
  static const smallButtonHeight = 40.0;
  static const shortAppBarSpacing = 22.0;
  static const tabsSwitchRadius = 40.0;
  static const cardSpacing = 8.0;
  static const detailsImageSize = 360.0;
  static const detailsTitleSpacing = 2.0;
  static const detailsHoursSpacing = 16.0;
  static const detailsCommonSpacing = 24.0;
  static const detailsFooterSpacing = 8.0;
  static const filtersSectionSpacing = 24.0;
  static const filtersCategorySize = 64.0;
  static const filtersCategorySpacing = 12.0;

  /// Цвета.
  static const buttonColor = Colors.green;
  static const primaryColorDarkest = Color(0xFF191A20);
  static const primaryColorDarker = Color(0xFF21222C);
  static const primaryColorDark = Color(0xFF252849);
  static const primaryColor = Color(0xFF3B3E5B);
  static const primaryColorLight = Color(0xFF7C7E92);
  static const primaryColorLightInactive = Color(0x8F7C7E92);
  static const primaryColorLighter = Color(0xFFF5F5F5);
  static const primaryColorLightest = Colors.white;
  static const tapOnImageHighlightColor = Colors.black26;
  static const tapOnImageSplashColor = Colors.black26;
  static const categoryActiveColor = Color(0xFF6ADA6F);
  static const categoryInactiveColor = Color(0x806ADA6F);
  static const categoryBackground = Color(0x296ADA6F);

  // Стили.
  static const _text = TextStyle(fontSize: 14, height: 18 / 14);
  static final textRegular = _text.copyWith(fontWeight: FontWeight.normal);
  static final textMiddle = textRegular.copyWith(fontWeight: FontWeight.w500);
  static final textBold = textRegular.copyWith(fontWeight: FontWeight.bold);
  static final textRegular12 =
      textRegular.copyWith(fontSize: 12, height: 16 / 12);
  static final textRegular16 = textRegular.copyWith(fontSize: 16, height: 1.25);
  static final textMiddle16 = textMiddle.copyWith(fontSize: 16, height: 1.25);
  static final textBold16 = textBold.copyWith(fontSize: 16, height: 1.25);
  static final textBold18 = textBold.copyWith(fontSize: 18, height: 1.25);
  static final textBold24 = textBold.copyWith(fontSize: 24, height: 1.2);
  static final textBold32 = textBold.copyWith(fontSize: 32, height: 1.125);

  /// Отступы.
  static const commonPadding = EdgeInsets.all(16);
  static final listPadding = commonPadding.copyWith(top: 8);
  static final appBarPadding = commonPadding.copyWith(top: 40, bottom: 8);
  static final shortAppBarPadding = commonPadding.copyWith(bottom: 22);
  static final detailsPadding = commonPadding.copyWith(top: 24);
  static const cardSignaturesPadding = EdgeInsets.only(top: 8, right: 8);
  static final filtersCaptionPadding =
      commonPadding.copyWith(top: 0, bottom: 0);
  static const appBarFiltersPadding = EdgeInsets.only(top: 8, bottom: 24);

  const MyThemeData({
    required this.appThemeData,
    required this.cardSignaturesTextStyle,
    required this.tapHighlightColor,
    required this.tapSplashColor,
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
  final Color tapHighlightColor;
  final Color tapSplashColor;

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
    primarySwatch: MyThemeData.buttonColor,
    primaryColor: MyThemeData.primaryColor,
    backgroundColor: MyThemeData.primaryColorLightest,
    scaffoldBackgroundColor: MyThemeData.primaryColorLightest,
    buttonTheme:
        _baseButtonTheme.copyWith(buttonColor: MyThemeData.buttonColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MyThemeData.primaryColorLightest,
      selectedItemColor: MyThemeData.primaryColor,
      unselectedItemColor: MyThemeData.primaryColor,
    ),
    cardTheme: _baseCardTheme.copyWith(color: MyThemeData.primaryColorLighter),
    primaryTextTheme: TextTheme(
      headline1:
          MyThemeData.textBold32.copyWith(color: MyThemeData.primaryColor),
      headline2:
          MyThemeData.textBold24.copyWith(color: MyThemeData.primaryColor),
      headline3:
          MyThemeData.textBold18.copyWith(color: MyThemeData.primaryColor),
      headline4:
          MyThemeData.textMiddle16.copyWith(color: MyThemeData.primaryColor),
      headline5:
          MyThemeData.textRegular16.copyWith(color: MyThemeData.primaryColor),
      headline6: MyThemeData.textBold.copyWith(color: MyThemeData.primaryColor),
      bodyText1:
          MyThemeData.textRegular.copyWith(color: MyThemeData.primaryColor),
      bodyText2:
          MyThemeData.textRegular12.copyWith(color: MyThemeData.primaryColor),
    ),
    textTheme: TextTheme(
      headline4: MyThemeData.textMiddle16
          .copyWith(color: MyThemeData.primaryColorLight),
      headline5: MyThemeData.textRegular16
          .copyWith(color: MyThemeData.primaryColorLight),
      headline6:
          MyThemeData.textBold.copyWith(color: MyThemeData.primaryColorLight),
      bodyText1: MyThemeData.textRegular
          .copyWith(color: MyThemeData.primaryColorLight),
      bodyText2: MyThemeData.textRegular12
          .copyWith(color: MyThemeData.primaryColorLight),
    ),
  ),
  cardSignaturesTextStyle:
      MyThemeData.textBold.copyWith(color: MyThemeData.primaryColorLightest),
  tapHighlightColor: Colors.black12,
  tapSplashColor: Colors.black12,
  standartButtonTextStyle:
      MyThemeData.textBold.copyWith(color: MyThemeData.primaryColorLightest),
  flatButtonTextStyle:
      MyThemeData.textRegular.copyWith(color: MyThemeData.primaryColor),
  flatButtonInactiveTextStyle: MyThemeData.textRegular
      .copyWith(color: MyThemeData.primaryColorLightInactive),
  tabSwitchActiveColor: MyThemeData.primaryColor,
  tabSwitchActiveTextStyle:
      MyThemeData.textBold.copyWith(color: MyThemeData.primaryColorLightest),
  tabSwitchInactiveColor: MyThemeData.primaryColorLighter,
  tabSwitchInactiveTextStyle: MyThemeData.textBold
      .copyWith(color: MyThemeData.primaryColorLightInactive),
);

final myDarkTheme = MyThemeData(
  appThemeData: ThemeData(
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    primarySwatch: MyThemeData.buttonColor,
    primaryColor: MyThemeData.primaryColorLightest,
    backgroundColor: MyThemeData.primaryColorDarker,
    scaffoldBackgroundColor: MyThemeData.primaryColorDarker,
    buttonTheme:
        _baseButtonTheme.copyWith(buttonColor: MyThemeData.buttonColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MyThemeData.primaryColorDarker,
      selectedItemColor: MyThemeData.primaryColorLightest,
      unselectedItemColor: MyThemeData.primaryColorLightest,
    ),
    cardTheme: _baseCardTheme.copyWith(color: MyThemeData.primaryColorDarkest),
    primaryTextTheme: TextTheme(
      headline1: MyThemeData.textBold32
          .copyWith(color: MyThemeData.primaryColorLightest),
      headline2: MyThemeData.textBold24
          .copyWith(color: MyThemeData.primaryColorLightest),
      headline3: MyThemeData.textBold18
          .copyWith(color: MyThemeData.primaryColorLightest),
      headline4: MyThemeData.textMiddle16
          .copyWith(color: MyThemeData.primaryColorLightest),
      headline5: MyThemeData.textRegular16
          .copyWith(color: MyThemeData.primaryColorLightest),
      headline6: MyThemeData.textBold
          .copyWith(color: MyThemeData.primaryColorLightest),
      bodyText1: MyThemeData.textRegular
          .copyWith(color: MyThemeData.primaryColorLightest),
      bodyText2: MyThemeData.textRegular12
          .copyWith(color: MyThemeData.primaryColorLightest),
    ),
    textTheme: TextTheme(
      headline4: MyThemeData.textMiddle16
          .copyWith(color: MyThemeData.primaryColorLight),
      headline5: MyThemeData.textRegular16
          .copyWith(color: MyThemeData.primaryColorLight),
      headline6:
          MyThemeData.textBold.copyWith(color: MyThemeData.primaryColorLight),
      bodyText1: MyThemeData.textRegular
          .copyWith(color: MyThemeData.primaryColorLight),
      bodyText2: MyThemeData.textRegular12
          .copyWith(color: MyThemeData.primaryColorLight),
    ),
  ),
  cardSignaturesTextStyle:
      MyThemeData.textBold.copyWith(color: MyThemeData.primaryColorLightest),
  tapHighlightColor: Colors.white12,
  tapSplashColor: Colors.white12,
  standartButtonTextStyle:
      MyThemeData.textBold.copyWith(color: MyThemeData.primaryColorLightest),
  flatButtonTextStyle:
      MyThemeData.textRegular.copyWith(color: MyThemeData.primaryColorLightest),
  flatButtonInactiveTextStyle: MyThemeData.textRegular
      .copyWith(color: MyThemeData.primaryColorLightInactive),
  tabSwitchActiveColor: MyThemeData.primaryColorLightest,
  tabSwitchActiveTextStyle:
      MyThemeData.textBold.copyWith(color: MyThemeData.primaryColor),
  tabSwitchInactiveColor: MyThemeData.primaryColorDarkest,
  tabSwitchInactiveTextStyle:
      MyThemeData.textBold.copyWith(color: MyThemeData.primaryColorLight),
);
