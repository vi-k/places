/// Собственная тема приложения, т.к. средств обычной ThemeData в нашем случае
/// недостаточно.
///
/// Свой вариант у Flutter team:
/// https://github.com/flutter/gallery/tree/master/lib/themes

import 'package:flutter/material.dart';

/// Цвета.
const _mainColor20 = Color(0xFF1A1A20);
const _mainColor30 = Color(0xFF21222C);
const _mainColor40 = Color(0xFF252849);
const _mainColor50 = Color(0xFF3B3E5B);
const _mainColor70 = Color(0xFF7C7E92);
const _mainColor70a56 = Color(0x8F7C7E92);
const _mainColor90 = Color(0xFFF5F5F5);
const _mainColor100 = Color(0xFFFFFFFF);
const _accentColor50 = Color(0xFF4CAF50);
const _accentColor50a16 = Color(0x294CAF50);
const _accentColor50a40 = Color(0x664CAF50);
const _accentColor70 = Color(0xFF6ADA6F);
const _accentColor70a16 = Color(0x296ADA6F);
const _accentColor70a40 = Color(0x666ADA6F);
const _attentionColor50 = Color(0xFFCF2A2A);
const _attentionColor50a16 = Color(0x29CF2A2A);
const _attentionColor50a40 = Color(0x66CF2A2A);
const _attentionColor70 = Color(0xFFEF4343);
const _attentionColor70a16 = Color(0x29EF4343);
const _attentionColor70a40 = Color(0x66EF4343);

const _highlightColorDark = Color(0x30000000);
const _splashColorDark = Color(0x30000000);
const _highlightColorLight = Color(0x30FFFFFF);
const _splashColorLight = Color(0x30FFFFFF);
const _highlightColorDark2 = Colors.black26;
const _splashColorDark2 = Colors.black26;

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

class MyThemeData {
  /// Константы.
  static const cardSpacing = 8.0;
  static const detailsCommonSpacing = 24.0;
  static const detailsFooterSpacing = 8.0;
  static const detailsHoursSpacing = 16.0;
  static const detailsImageSize = 360.0;
  static const detailsTitleSpacing = 2.0;
  static const filtersCategorySize = 64.0;
  static const filtersCategorySpacing = 12.0;
  static const filtersSectionSpacing = 24.0;
  static const shortAppBarSpacing = 22.0;
  static const smallButtonHeight = 40.0;
  static const smallButtonRadius = 40.0;
  static const textFieldBorderWidth = 1.0;
  static const textFieldFocusedBorderWidth = 2.0;
  static const textFieldRadius = 8.0;
  static const tabsSwitchRadius = 40.0;
  static const sectionTop = 24.0;
  static const sectionHSpacing = 16.0;
  static const sectionVSpacing = 12.0;

  /// Отступы.
  static const commonPadding = EdgeInsets.all(16);
  static const commonPaddingLR = EdgeInsets.only(left: 16, right: 16);
  static const commonPaddingLBR =
      EdgeInsets.only(left: 16, right: 16, bottom: 16);
  static final listPadding = commonPadding.copyWith(top: 8);
  static final appBarPadding = commonPadding.copyWith(top: 40);
  static const shortAppBarPadding = commonPadding;
  static final detailsPadding = commonPadding.copyWith(top: 24);
  static const cardSignaturesPadding = EdgeInsets.only(top: 8, right: 8);
  static final filtersCaptionPadding =
      commonPadding.copyWith(top: 0, bottom: 0);
  static const appBarFiltersPadding = EdgeInsets.only(top: 8, bottom: 24);

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
    this.highlightColorOnImage = _highlightColorDark2,
    this.splashColorOnImage = _splashColorDark2,
    required this.specialInputDecorationTheme,
  }) {
    textRegular12Main = _textRegular12.withColor(mainTextColor);
    textRegular12Light56 = _textRegular12.withColor(lightTextColor56);

    textRegular14Main = _textRegular14.withColor(mainTextColor);
    textRegular14Light = _textRegular14.withColor(lightTextColor);
    textRegular14Light56 = _textRegular14.withColor(lightTextColor56);

    textBold14Light = _textBold14.withColor(lightTextColor);
    textBold14Inverse = _textBold14.withColor(inverseTextColor);
    textBold14White = _textBold14.withColor(_mainColor100);

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
  final Color highlightColorOnImage;
  final Color splashColorOnImage;

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
  thumbColor: _mainColor100,
  inactiveTrackColor: _mainColor70a56,
  trackHeight: 2,
  rangeTrackShape: RectangularRangeSliderTrackShape(),
  rangeThumbShape: RoundRangeSliderThumbShape(
    enabledThumbRadius: 8,
    elevation: 2,
  ),
);

InputBorder _border(Color? color, {bool focused = false}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(MyThemeData.textFieldRadius),
      borderSide: color == null
          ? const BorderSide(color: Colors.transparent, width: 0)
          : BorderSide(
              color: color,
              width: focused
                  ? MyThemeData.textFieldFocusedBorderWidth
                  : MyThemeData.textFieldBorderWidth),
    );

const _baseInputDecorationTheme = InputDecorationTheme(
  contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 0),
);

final myLightTheme = MyThemeData(
  app: ThemeData(
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    primarySwatch: Colors.pink, // Для проверки, что все цвета заменены
    accentColor: _accentColor50,
    backgroundColor: _mainColor100,
    scaffoldBackgroundColor: _mainColor100,
    canvasColor: _mainColor90,
    highlightColor: _highlightColorDark, //Colors.orange,
    splashColor: _splashColorDark,
    buttonTheme: _baseButtonTheme.copyWith(
      buttonColor: _accentColor50,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: _mainColor100,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _mainColor100,
      selectedItemColor: _mainColor50,
      unselectedItemColor: _mainColor50,
    ),
    cardTheme: _baseCardTheme.copyWith(
      color: _mainColor90,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: _accentColor50a40,
      selectionHandleColor: _accentColor50,
      cursorColor: _accentColor50,
    ),
    inputDecorationTheme: _baseInputDecorationTheme.copyWith(
      hintStyle: const TextStyle(
          color: _mainColor70a56), // Размеры установятся как у базового
      errorStyle: const TextStyle(color: _attentionColor50),
      helperStyle: const TextStyle(color: _mainColor70),
      enabledBorder: _border(_accentColor50a40),
      focusedBorder: _border(_accentColor50a40, focused: true),
      errorBorder: _border(_attentionColor50a40),
      focusedErrorBorder: _border(_attentionColor50a40, focused: true),
    ),
    sliderTheme: _baseSliderTheme.copyWith(
      activeTrackColor: _accentColor50,
      overlayColor: _accentColor50a16,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(_mainColor100),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
          states.contains(MaterialState.selected)
              ? _accentColor50
              : _mainColor70a56),
      overlayColor: MaterialStateProperty.all<Color>(_accentColor50a16),
    ),
    textTheme: TextTheme(
      // Стиль для TextField
      subtitle1: _textRegular16.withColor(_mainColor40), // = textRegular16Main2
    ),
  ),
  accentColor: _accentColor50,
  accentColor16: _accentColor50a16,
  accentColor40: _accentColor50a40,
  attentionColor: _attentionColor50,
  attentionColor16: _attentionColor50a16,
  attentionColor40: _attentionColor50a40,
  mainTextColor: _mainColor50,
  mainTextColor2: _mainColor40,
  inverseTextColor: _mainColor100,
  lightTextColor: _mainColor70,
  lightTextColor56: _mainColor70a56,
  backgroundFirst: _mainColor100,
  backgroundSecond: _mainColor90,
  specialInputDecorationTheme: _baseInputDecorationTheme.copyWith(
    hintStyle: const TextStyle(
        color: _mainColor70a56), // Размеры установятся как у базового
    errorStyle: const TextStyle(color: _attentionColor50),
    helperStyle: const TextStyle(color: _mainColor70),
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
    accentColor: _accentColor70,
    backgroundColor: _mainColor30,
    scaffoldBackgroundColor: _mainColor30,
    canvasColor: _mainColor20,
    highlightColor: _highlightColorLight,
    splashColor: _splashColorLight,
    buttonTheme: _baseButtonTheme.copyWith(
      buttonColor: _accentColor70,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: _mainColor100,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _mainColor30,
      selectedItemColor: _mainColor100,
      unselectedItemColor: _mainColor100,
    ),
    cardTheme: _baseCardTheme.copyWith(
      color: _mainColor20,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: _accentColor70a40,
      selectionHandleColor: _accentColor70,
      cursorColor: _accentColor70,
    ),
    inputDecorationTheme: _baseInputDecorationTheme.copyWith(
      hintStyle: const TextStyle(
          color: _mainColor70a56), // Размеры установятся как у базового
      errorStyle: const TextStyle(color: _attentionColor70),
      helperStyle: const TextStyle(color: _mainColor70),
      enabledBorder: _border(_accentColor70a40),
      focusedBorder: _border(_accentColor70a40, focused: true),
      errorBorder: _border(_attentionColor70a40),
      focusedErrorBorder: _border(_attentionColor70a40, focused: true),
    ),
    sliderTheme: _baseSliderTheme.copyWith(
      activeTrackColor: _accentColor70,
      overlayColor: _accentColor70a16,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(_mainColor100),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
          states.contains(MaterialState.selected)
              ? _accentColor70
              : _mainColor70a56),
      overlayColor: MaterialStateProperty.all<Color>(_accentColor50a16),
    ),
    textTheme: TextTheme(
      // Стиль для TextField
      subtitle1: _textRegular16.withColor(_mainColor100), // = textRegular16Main
    ),
  ),
  accentColor: _accentColor70,
  accentColor16: _accentColor70a16,
  accentColor40: _accentColor70a40,
  attentionColor: _attentionColor70,
  attentionColor16: _attentionColor70a16,
  attentionColor40: _attentionColor70a40,
  mainTextColor: _mainColor100,
  mainTextColor2: _mainColor100,
  inverseTextColor: _mainColor50,
  lightTextColor: _mainColor70,
  lightTextColor56: _mainColor70a56,
  backgroundFirst: _mainColor30,
  backgroundSecond: _mainColor20,
  specialInputDecorationTheme: _baseInputDecorationTheme.copyWith(
    hintStyle: const TextStyle(
        color: _mainColor70a56), // Размеры установятся как у базового
    errorStyle: const TextStyle(color: _attentionColor70),
    helperStyle: const TextStyle(color: _mainColor70),
    enabledBorder: _border(null),
    focusedBorder: _border(null, focused: true),
    errorBorder: _border(null),
    focusedErrorBorder: _border(null, focused: true),
  ),
);
