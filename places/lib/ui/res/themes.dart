/// Собственная тема приложения, т.к. средств обычной ThemeData в нашем случае
/// недостаточно.
///
/// Свой вариант у Flutter team:
/// https://github.com/flutter/gallery/tree/master/lib/themes

import 'package:flutter/material.dart';

/// Цвета.
const mainColor20 = Color(0xFF1A1A20);
const mainColor30 = Color(0xFF21222C);
const mainColor40 = Color(0xFF252849);
const mainColor50 = Color(0xFF3B3E5B);
const mainColor70 = Color(0xFF7C7E92);
const mainColor70a56 = Color(0x8F7C7E92);
const mainColor90 = Color(0xFFF5F5F5);
const mainColor100 = Color(0xFFFFFFFF);
const accentColor50 = Color(0xFF4CAF50);
const accentColor50a16 = Color(0x294CAF50);
const accentColor50a40 = Color(0x664CAF50);
const accentColor70 = Color(0xFF6ADA6F);
const accentColor70a16 = Color(0x296ADA6F);
const accentColor70a40 = Color(0x666ADA6F);
const attentionColor50 = Color(0xFFCF2A2A);
const attentionColor50a16 = Color(0x29CF2A2A);
const attentionColor50a40 = Color(0x66CF2A2A);
const attentionColor70 = Color(0xFFEF4343);
const attentionColor70a16 = Color(0x29EF4343);
const attentionColor70a40 = Color(0x66EF4343);

const highlightColorDark = Color(0x30000000);
const splashColorDark = Color(0x30000000);
const highlightColorLight = Color(0x30FFFFFF);
const splashColorLight = Color(0x30FFFFFF);
const highlightColorDark2 = Colors.black26;
const splashColorDark2 = Colors.black26;

// Стили.
const _textRegular = TextStyle(fontWeight: FontWeight.normal);
const _textMiddle = TextStyle(fontWeight: FontWeight.w500);
const _textBold = TextStyle(fontWeight: FontWeight.bold);

final _textRegular12 = _textRegular.copyWith(fontSize: 12, height: 1.33);
final _textRegular14 = _textRegular.copyWith(fontSize: 14, height: 1.29);
final _textBold14 = _textBold.copyWith(fontSize: 14, height: 1.29);
final _textRegular16 = _textRegular.copyWith(fontSize: 16, height: 1.25);
final _textMiddle16 = _textMiddle.copyWith(fontSize: 16, height: 1.25);
final _textMiddle18 = _textMiddle.copyWith(fontSize: 18, height: 1.25);
final _textBold24 = _textBold.copyWith(fontSize: 24, height: 1.2);
final _textBold32 = _textBold.copyWith(fontSize: 32, height: 1.125);

extension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
}

/// Публичные константы.
const commonSpacing = 16.0;
const commonSpacing1_2 = commonSpacing / 2; // 8
const commonSpacing3_4 = commonSpacing * 3 / 4; // 12
const commonSpacing3_2 = commonSpacing * 3 / 2; // 24
const detailsImageSize = 360.0;
const filtersCategorySize = 64.0;
const smallButtonHeight = 40.0;
const smallButtonRadius = 40.0;
const textFieldBorderWidth = 1.0;
const textFieldFocusedBorderWidth = 2.0;
const textFieldRadius = 8.0;
const tabsSwitchRadius = 40.0;
const sectionTop = 24.0;
const photoCardSize = 72.0;
const tickChoiceSize = 16.0;
const clearIconSize = 20.0;
const clearButtonSize = 24.0;

/// Отступы.
const commonPadding = EdgeInsets.all(16);
const commonPaddingLR = EdgeInsets.only(left: 16, right: 16);
const commonPaddingLBR = EdgeInsets.only(left: 16, right: 16, bottom: 16);
const commonPaddingLTR = EdgeInsets.only(left: 16, top: 16, right: 16);
const appBarPadding = EdgeInsets.only(left: 16, top: 40, right: 16, bottom: 16);
const detailsPadding =
    EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 16);
const cardSignaturesPadding = EdgeInsets.only(top: 8, right: 8);
const appBarFiltersPadding = EdgeInsets.only(top: 8, bottom: 24);
const clearPadding = EdgeInsets.all(4);

class MyThemeData {
  MyThemeData({
    required this.app,
    required this.accentColor,
    required this.accentColor16,
    required this.accentColor40,
    required this.attentionColor,
    required this.attentionColor16,
    required this.attentionColor40,
    required this.mainTextColor,
    required this.mainTextColor2,
    required this.lightTextColor,
    required this.lightTextColor56,
    required this.inverseTextColor,
    required this.backgroundFirst,
    required this.backgroundSecond,
    required this.specialInputDecorationTheme,
  }) {
    textRegular12Main = _textRegular12.withColor(mainTextColor);
    textRegular12Light56 = _textRegular12.withColor(lightTextColor56);

    textRegular14Main = _textRegular14.withColor(mainTextColor);
    textRegular14Light = _textRegular14.withColor(lightTextColor);
    textRegular14Light56 = _textRegular14.withColor(lightTextColor56);

    textBold14Light = _textBold14.withColor(lightTextColor);
    textBold14Inverse = _textBold14.withColor(inverseTextColor);
    textBold14White = _textBold14.withColor(mainColor100);

    textRegular16Main = _textRegular16.withColor(mainTextColor);
    textRegular16Main2 = _textRegular16.withColor(mainTextColor2);
    textRegular16Light = _textRegular16.withColor(lightTextColor);
    textRegular16Light56 = _textRegular16.withColor(lightTextColor56);

    textMiddle16Accent = _textMiddle16.withColor(accentColor);
    textMiddle16Main = _textMiddle16.withColor(mainTextColor);
    textMiddle16Light = _textMiddle16.withColor(lightTextColor);

    textMiddle18Main2 = _textMiddle18.withColor(mainTextColor2);
    textBold24Main = _textBold24.withColor(mainTextColor);
    textBold32Main = _textBold32.withColor(mainTextColor);
  }

  final ThemeData app;
  final Color accentColor;
  final Color accentColor16;
  final Color accentColor40;
  final Color attentionColor;
  final Color attentionColor16;
  final Color attentionColor40;
  final Color mainTextColor;
  final Color mainTextColor2;
  final Color inverseTextColor;
  final Color lightTextColor;
  final Color lightTextColor56;
  final Color backgroundFirst;
  final Color backgroundSecond;

  late final TextStyle textRegular12Main;
  late final TextStyle textRegular12Light56;

  late final TextStyle textRegular14Main;
  late final TextStyle textRegular14Light;
  late final TextStyle textRegular14Light56;

  late final TextStyle textBold14Inverse;
  late final TextStyle textBold14Light;
  late final TextStyle textBold14White;

  late final TextStyle textRegular16Main;
  late final TextStyle textRegular16Main2;
  late final TextStyle textRegular16Light;
  late final TextStyle textRegular16Light56;

  late final TextStyle textMiddle16Accent;
  late final TextStyle textMiddle16Main;
  late final TextStyle textMiddle16Light;

  late final TextStyle textMiddle18Main2;
  late final TextStyle textBold24Main;
  late final TextStyle textBold32Main;

  final InputDecorationTheme specialInputDecorationTheme;
}

const _baseButtonTheme = ButtonThemeData(
  height: 48,
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

const _baseSliderTheme = SliderThemeData(
  thumbColor: mainColor100,
  inactiveTrackColor: mainColor70a56,
  trackHeight: 2,
  rangeTrackShape: RectangularRangeSliderTrackShape(),
  rangeThumbShape: RoundRangeSliderThumbShape(
    enabledThumbRadius: 8,
    elevation: 2,
  ),
);

InputBorder _border(Color? color, {bool focused = false}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(textFieldRadius),
      borderSide: color == null
          ? const BorderSide(color: Colors.transparent, width: 0)
          : BorderSide(
              color: color,
              width: focused
                  ? textFieldFocusedBorderWidth
                  : textFieldBorderWidth),
    );

const _baseInputDecorationTheme = InputDecorationTheme(
  contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 0),
);

final myLightTheme = MyThemeData(
  app: ThemeData(
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    primarySwatch: Colors.pink, // Для проверки, что все цвета заменены
    accentColor: accentColor50,
    backgroundColor: mainColor100,
    scaffoldBackgroundColor: mainColor100,
    canvasColor: mainColor90,
    highlightColor: highlightColorDark, //Colors.orange,
    splashColor: splashColorDark,
    buttonTheme: _baseButtonTheme.copyWith(
      buttonColor: accentColor50,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: mainColor100,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mainColor100,
      selectedItemColor: mainColor50,
      unselectedItemColor: mainColor50,
    ),
    cardTheme: _baseCardTheme.copyWith(
      color: mainColor90,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: accentColor50a40,
      selectionHandleColor: accentColor50,
      cursorColor: accentColor50,
    ),
    inputDecorationTheme: _baseInputDecorationTheme.copyWith(
      hintStyle: const TextStyle(
          color: mainColor70a56), // Размеры установятся как у базового
      errorStyle: const TextStyle(color: attentionColor50),
      helperStyle: const TextStyle(color: mainColor70),
      enabledBorder: _border(accentColor50a40),
      focusedBorder: _border(accentColor50a40, focused: true),
      errorBorder: _border(attentionColor50a40),
      focusedErrorBorder: _border(attentionColor50a40, focused: true),
    ),
    sliderTheme: _baseSliderTheme.copyWith(
      activeTrackColor: accentColor50,
      overlayColor: accentColor50a16,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(mainColor100),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
          states.contains(MaterialState.selected)
              ? accentColor50
              : mainColor70a56),
      overlayColor: MaterialStateProperty.all<Color>(accentColor50a16),
    ),
    textTheme: TextTheme(
      // Стиль для TextField
      subtitle1: _textRegular16.withColor(mainColor40), // = textRegular16Main2
    ),
  ),
  accentColor: accentColor50,
  accentColor16: accentColor50a16,
  accentColor40: accentColor50a40,
  attentionColor: attentionColor50,
  attentionColor16: attentionColor50a16,
  attentionColor40: attentionColor50a40,
  mainTextColor: mainColor50,
  mainTextColor2: mainColor40,
  inverseTextColor: mainColor100,
  lightTextColor: mainColor70,
  lightTextColor56: mainColor70a56,
  backgroundFirst: mainColor100,
  backgroundSecond: mainColor90,
  specialInputDecorationTheme: _baseInputDecorationTheme.copyWith(
    hintStyle: const TextStyle(
        color: mainColor70a56), // Размеры установятся как у базового
    errorStyle: const TextStyle(color: attentionColor50),
    helperStyle: const TextStyle(color: mainColor70),
    enabledBorder: _border(null),
    focusedBorder: _border(null, focused: true),
    errorBorder: _border(null),
    focusedErrorBorder: _border(null, focused: true),
  ),
);

final myDarkTheme = MyThemeData(
  app: ThemeData(
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    primarySwatch: Colors.pink, // Для проверки, что все цвета заменены
    accentColor: accentColor70,
    backgroundColor: mainColor30,
    scaffoldBackgroundColor: mainColor30,
    canvasColor: mainColor20,
    highlightColor: highlightColorLight,
    splashColor: splashColorLight,
    buttonTheme: _baseButtonTheme.copyWith(
      buttonColor: accentColor70,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: mainColor100,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mainColor30,
      selectedItemColor: mainColor100,
      unselectedItemColor: mainColor100,
    ),
    cardTheme: _baseCardTheme.copyWith(
      color: mainColor20,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: accentColor70a40,
      selectionHandleColor: accentColor70,
      cursorColor: accentColor70,
    ),
    inputDecorationTheme: _baseInputDecorationTheme.copyWith(
      hintStyle: const TextStyle(
          color: mainColor70a56), // Размеры установятся как у базового
      errorStyle: const TextStyle(color: attentionColor70),
      helperStyle: const TextStyle(color: mainColor70),
      enabledBorder: _border(accentColor70a40),
      focusedBorder: _border(accentColor70a40, focused: true),
      errorBorder: _border(attentionColor70a40),
      focusedErrorBorder: _border(attentionColor70a40, focused: true),
    ),
    sliderTheme: _baseSliderTheme.copyWith(
      activeTrackColor: accentColor70,
      overlayColor: accentColor70a16,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(mainColor100),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
          states.contains(MaterialState.selected)
              ? accentColor70
              : mainColor70a56),
      overlayColor: MaterialStateProperty.all<Color>(accentColor50a16),
    ),
    textTheme: TextTheme(
      // Стиль для TextField
      subtitle1: _textRegular16.withColor(mainColor100), // = textRegular16Main
    ),
  ),
  accentColor: accentColor70,
  accentColor16: accentColor70a16,
  accentColor40: accentColor70a40,
  attentionColor: attentionColor70,
  attentionColor16: attentionColor70a16,
  attentionColor40: attentionColor70a40,
  mainTextColor: mainColor100,
  mainTextColor2: mainColor100,
  inverseTextColor: mainColor50,
  lightTextColor: mainColor70,
  lightTextColor56: mainColor70a56,
  backgroundFirst: mainColor30,
  backgroundSecond: mainColor20,
  specialInputDecorationTheme: _baseInputDecorationTheme.copyWith(
    hintStyle: const TextStyle(
        color: mainColor70a56), // Размеры установятся как у базового
    errorStyle: const TextStyle(color: attentionColor70),
    helperStyle: const TextStyle(color: mainColor70),
    enabledBorder: _border(null),
    focusedBorder: _border(null, focused: true),
    errorBorder: _border(null),
    focusedErrorBorder: _border(null, focused: true),
  ),
);
