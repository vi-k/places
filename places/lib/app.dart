import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'domain/settings_data.dart';
import 'ui/res/themes.dart';
import 'ui/screen/splash_screen.dart';
import 'ui/widget/settings.dart';

/// Основной виджет-приложение.
///
/// Передаёт по дереву настройки (SettingsData), данные (MocksData)
/// и тему (MyThemeData).
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => Settings(
        create: () => SettingsData(isDark: true),
        child: Builder(
          builder: (context) => MyTheme(
            myThemeData: Settings.of(context, listen: true).isDark
                ? myDarkTheme
                : myLightTheme,
            child: Builder(
              builder: (context) => MaterialApp(
                title: 'Places',
                theme: MyTheme.of(context).app,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ru'),
                ],
                home: SplashScreen(),
              ),
            ),
          ),
        ),
      );
}
