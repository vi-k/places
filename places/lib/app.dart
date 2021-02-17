import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'domain/settings_data.dart';
import 'main.dart';
import 'ui/res/themes.dart';
import 'ui/screen/splash_screen.dart';
import 'ui/widget/failed.dart';
import 'ui/widget/loader.dart';

/// Основной виджет-приложение.
///
/// Передаёт по дереву настройки (SettingsData), данные (MocksData)
/// и тему (MyThemeData).
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Временно реализую загрузку данных через свой Loader в надежде потом перейти
  // на что-нибудь посерьёзней.
  @override
  Widget build(BuildContext context) => Loader<SettingsData>(
        load: settingsInteractor.loadSettings,
        error: (context, error) => MyTheme(
          myThemeData: myDarkTheme,
          child: Builder(
            builder: (context) => MaterialApp(
              title: 'Places',
              theme: MyTheme.of(context).app,
              home: Scaffold(
                body: Failed(
                  message: 'Не удалось инициализировать приложение. '
                      'Обратитесь к разработчику\n\n$error',
                  onRepeat: () => Loader.of<SettingsData>(context).reload(),
                ),
              ),
            ),
          ),
        ),
        cleanBuilder: true,
        builder: (context, state, settings) => MyTheme(
          myThemeData: (settings?.isDark ?? true) ? myDarkTheme : myLightTheme,
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
              home: SplashScreen(
                key: ValueKey(settings != null),
                navigate: settings != null,
              ),
            ),
          ),
        ),
      );
}
