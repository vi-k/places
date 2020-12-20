import 'package:flutter/material.dart';

import 'domain/settings.dart';
import 'ui/res/themes.dart';
import 'ui/screen/filters_screen.dart';
import 'ui/widget/my_theme.dart';

class App extends StatefulWidget {
  static _AppState of(BuildContext context) =>
      context.findRootAncestorStateOfType<_AppState>()!;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late Settings settings;

  @override
  void initState() {
    super.initState();

    settings = Settings(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => MyTheme(
        myThemeData: settings.isDark ? myDarkTheme : myLightTheme,
        child: AppBody(),
      );
}

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Places',
        theme: MyTheme.of(context).appThemeData,
        home: FiltersScreen(),
        // home: SightListScreen(),
      );
}
