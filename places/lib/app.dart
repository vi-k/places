import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/settings.dart';
import 'mocks.dart';
import 'ui/res/themes.dart';
import 'ui/screen/sight_list_screen.dart';
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

    settings = Settings(
      isDark: true,
      onUpdate: () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) => MyTheme(
        myThemeData: settings.isDark ? myDarkTheme : myLightTheme,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Mocks()),
          ],
          child: AppBody(),
        ),
      );
}

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Places',
        theme: MyTheme.of(context).app,
        home: SightListScreen(),
      );
}
