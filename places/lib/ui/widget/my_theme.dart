/// Виджет для предоставления собственной темы приложения вниз по дереву.
///
/// Доступ: `MyTheme.of(context)`. Возвращает MyThemeData (не MyThemeData?),
/// поэтому, если вверху дерева не будет виджета, приложение рухнет.
/// Подразумевается, что тот, кто пользуется, тот понимает, что он делает,
/// а функция убирает лишнюю необходимость заботиться о null.

import 'package:flutter/material.dart';

import '../res/themes.dart';

class MyTheme extends InheritedWidget {
  const MyTheme({
    Key? key,
    required Widget child,
    required this.myThemeData,
  }) : super(key: key, child: child);

  final MyThemeData myThemeData;

  static MyThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MyTheme>()!.myThemeData;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
