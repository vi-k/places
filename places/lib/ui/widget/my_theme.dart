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
