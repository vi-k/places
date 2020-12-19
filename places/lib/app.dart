import 'package:flutter/material.dart';

import 'ui/res/themes.dart';
import 'ui/screen/filters_screen.dart';
import 'ui/screen/sight_list_screen.dart';
import 'ui/widget/my_theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MyTheme(
        myThemeData: myLightTheme,
        // myThemeData: myDarkTheme,
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
