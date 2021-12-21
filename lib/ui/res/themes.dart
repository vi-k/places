import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:places/utils/let_and_also.dart';

import 'const.dart';

/// Собственная тема приложения, т.к. средств обычной ThemeData в нашем случае
/// недостаточно.
///
/// Свой вариант у Flutter team:
/// https://github.com/flutter/gallery/tree/master/lib/themes

// Стили.
const _textRegular = TextStyle(fontWeight: FontWeight.normal);
const _textMiddle = TextStyle(fontWeight: FontWeight.w500);
const _textBold = TextStyle(fontWeight: FontWeight.bold);

final _textRegular12 = _textRegular.copyWith(fontSize: 12, height: 16 / 12);
final _textMiddle12 = _textMiddle.copyWith(fontSize: 12, height: 16 / 12);
final _textRegular14 = _textRegular.copyWith(fontSize: 14, height: 18 / 14);
final _textMiddle14 = _textBold.copyWith(fontSize: 14, height: 18 / 14);
final _textBold14 = _textBold.copyWith(fontSize: 14, height: 18 / 14);
final _textRegular16 = _textRegular.copyWith(fontSize: 16, height: 20 / 16);
final _textMiddle16 = _textMiddle.copyWith(fontSize: 16, height: 20 / 16);
final _textMiddle18 = _textMiddle.copyWith(fontSize: 18, height: 22.5 / 16);
final _textBold24 = _textBold.copyWith(fontSize: 24, height: 1.2);
final _textBold32 = _textBold.copyWith(fontSize: 32, height: 36 / 32);

extension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
}

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
    textRegular12Attention = _textRegular12.withColor(attentionColor);

    textMiddle12White = _textMiddle12.withColor(mainColor100);

    textRegular14Accent = _textRegular14.withColor(accentColor);
    textRegular14Main = _textRegular14.withColor(mainTextColor);
    textRegular14Light = _textRegular14.withColor(lightTextColor);
    textRegular14Light56 = _textRegular14.withColor(lightTextColor56);

    textMiddle14Accent = _textMiddle14.withColor(accentColor);
    textMiddle14White = _textMiddle14.withColor(mainColor100);

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
    textMiddle18Light56 = _textMiddle18.withColor(lightTextColor56);
    textBold24Main = _textBold24.withColor(mainTextColor);
    textBold24Main2 = _textBold24.withColor(mainTextColor2);
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
  late final TextStyle textRegular12Attention;

  late final TextStyle textMiddle12White;

  late final TextStyle textRegular14Accent;
  late final TextStyle textRegular14Main;
  late final TextStyle textRegular14Light;
  late final TextStyle textRegular14Light56;

  late final TextStyle textMiddle14Accent;
  late final TextStyle textMiddle14White;

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
  late final TextStyle textMiddle18Light56;
  late final TextStyle textBold24Main;
  late final TextStyle textBold24Main2;
  late final TextStyle textBold32Main;

  final InputDecorationTheme specialInputDecorationTheme;
}

const _baseButtonTheme = ButtonThemeData();

final _baseTextButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    padding: MaterialStateProperty.all(commonPaddingLR * 3 / 2),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000), // Всегда максимально круглая
      ),
    ),
    minimumSize: MaterialStateProperty.all(Size.zero),
  ),
);

final _baseElevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    minimumSize: MaterialStateProperty.all(Size.zero),
    // padding: MaterialStateProperty.all(EdgeInsets.zero),
    shape: MaterialStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(standartButtonRadius),
        ),
      ),
    ),
  ),
);

const _baseCardTheme = CardTheme(
  margin: EdgeInsets.zero,
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(commonSpacing)),
  ),
  elevation: 4,
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
      borderSide: color?.let((it) => BorderSide(
                color: it,
                width: focused
                    ? textFieldFocusedBorderWidth
                    : textFieldBorderWidth,
              )) ??
          const BorderSide(color: Colors.transparent, width: 0),
    );

// Высота TextField = 40 (10 + 10 + 20 (размер шрифта))
const _baseInputDecorationTheme = InputDecorationTheme(
  isDense: true,
  contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
);

// ignore: long-method
MyThemeData createLightTheme() => MyThemeData(
      app: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.light,
        primarySwatch: MaterialColor(accentColor50.value, {
          50: Color.alphaBlend(accentColor50, Colors.white.withOpacity(0.9)),
          100: Color.alphaBlend(accentColor50, Colors.white.withOpacity(0.8)),
          200: Color.alphaBlend(accentColor50, Colors.white.withOpacity(0.6)),
          300: Color.alphaBlend(accentColor50, Colors.white.withOpacity(0.4)),
          400: Color.alphaBlend(accentColor50, Colors.white.withOpacity(0.2)),
          500: accentColor50,
          600: Color.alphaBlend(accentColor50, Colors.black.withOpacity(0.1)),
          700: Color.alphaBlend(accentColor50, Colors.black.withOpacity(0.2)),
          800: Color.alphaBlend(accentColor50, Colors.black.withOpacity(0.3)),
          900: Color.alphaBlend(accentColor50, Colors.black.withOpacity(0.4)),
        }),
        accentColor: accentColor50,
        backgroundColor: mainColor100,
        scaffoldBackgroundColor: mainColor100,
        canvasColor: mainColor90,
        highlightColor: highlightColorDark,
        splashColor: splashColorDark,
        buttonTheme: _baseButtonTheme,
        textButtonTheme: _baseTextButtonTheme,
        elevatedButtonTheme: _baseElevatedButtonTheme,
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
          hintStyle: const TextStyle(color: mainColor70a56),
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
          subtitle1:
              _textRegular16.withColor(mainColor40), // = textRegular16Main2
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: _textRegular16.withColor(mainColor50),
          ),
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
        hintStyle: const TextStyle(color: mainColor70a56),
        errorStyle: const TextStyle(color: attentionColor50),
        helperStyle: const TextStyle(color: mainColor70),
        enabledBorder: _border(null),
        focusedBorder: _border(null, focused: true),
        errorBorder: _border(null),
        focusedErrorBorder: _border(null, focused: true),
      ),
    );

// ignore: long-method
MyThemeData createDarkTheme() => MyThemeData(
      app: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        primarySwatch: MaterialColor(accentColor70.value, {
          50: Color.alphaBlend(accentColor70, Colors.white.withOpacity(0.9)),
          100: Color.alphaBlend(accentColor70, Colors.white.withOpacity(0.8)),
          200: Color.alphaBlend(accentColor70, Colors.white.withOpacity(0.6)),
          300: Color.alphaBlend(accentColor70, Colors.white.withOpacity(0.4)),
          400: Color.alphaBlend(accentColor70, Colors.white.withOpacity(0.2)),
          500: accentColor70,
          600: Color.alphaBlend(accentColor70, Colors.black.withOpacity(0.1)),
          700: Color.alphaBlend(accentColor70, Colors.black.withOpacity(0.2)),
          800: Color.alphaBlend(accentColor70, Colors.black.withOpacity(0.3)),
          900: Color.alphaBlend(accentColor70, Colors.black.withOpacity(0.4)),
        }),
        accentColor: accentColor70,
        backgroundColor: mainColor30,
        scaffoldBackgroundColor: mainColor30,
        canvasColor: mainColor20,
        highlightColor: highlightColorLight,
        splashColor: splashColorLight,
        buttonTheme: _baseButtonTheme,
        textButtonTheme: _baseTextButtonTheme,
        elevatedButtonTheme: _baseElevatedButtonTheme,
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
          hintStyle: const TextStyle(color: mainColor70a56),
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
          subtitle1:
              _textRegular16.withColor(mainColor100), // = textRegular16Main
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark,
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: _textRegular16.withColor(mainColor100),
          ),
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
        hintStyle: const TextStyle(color: mainColor70a56),
        errorStyle: const TextStyle(color: attentionColor70),
        helperStyle: const TextStyle(color: mainColor70),
        enabledBorder: _border(null),
        focusedBorder: _border(null, focused: true),
        errorBorder: _border(null),
        focusedErrorBorder: _border(null, focused: true),
      ),
    );
