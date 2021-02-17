import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                // Зачем-то вставлял, но уже забыл - зачем.
                // А между этими строками и intl какой-то конфликт.
                // Без них, вроде, работает. Но пока оставлю, чтобы потом
                // не восстанавливать, если вдруг всё же надо.
                // localizationsDelegates: const [
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   GlobalCupertinoLocalizations.delegate,
                // ],
                // supportedLocales: const [
                //   Locale('ru'),
                // ],
                home: SplashScreen(),
              ),
            ),
          ),
        ),
      );
}
