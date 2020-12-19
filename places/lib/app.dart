import 'package:flutter/material.dart';

import 'ui/res/themes.dart';
import 'ui/screen/filters_screen.dart';
import 'ui/screen/sight_list_screen.dart';
import 'ui/widget/my_theme.dart';

MyThemeData globalMyThemeData = myLightTheme;

class App extends StatefulWidget {
  static void update(BuildContext context) {
    globalMyThemeData =
        globalMyThemeData == myDarkTheme ? myLightTheme : myDarkTheme;
    context.findRootAncestorStateOfType<_AppState>()!.update();
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  void update() => setState(() {});

  @override
  Widget build(BuildContext context) => MyTheme(
        myThemeData: globalMyThemeData,
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
