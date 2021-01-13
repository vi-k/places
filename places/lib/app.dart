import 'package:flutter/material.dart';

import 'domain/mocks_data.dart';
import 'domain/settings_data.dart';
import 'ui/res/themes.dart';
import 'ui/screen/onboarding_screen.dart';
import 'ui/widget/mocks.dart';
import 'ui/widget/settings.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => Settings(
        create: () => SettingsData(isDark: true),
        child: Mocks(
          create: () => MocksData(),
          child: Builder(
              builder: (context) => MyTheme(
                    myThemeData: Settings.of(context, listen: true).isDark
                        ? myDarkTheme
                        : myLightTheme,
                    child: AppBody(),
                  )),
        ),
      );
}

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Places',
        theme: MyTheme.of(context).app,
        home: OnboardingScreen(),
      );
}
