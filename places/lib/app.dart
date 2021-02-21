import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/place_list_screen.dart';

import 'data/model/settings.dart';
import 'main.dart';
import 'ui/res/themes.dart';
import 'ui/screen/splash_screen.dart';
import 'ui/widget/failed.dart';
import 'ui/widget/loader.dart';

/// Основной виджет-приложение.
///
/// Передаёт по дереву настройки (Setting) и тему (MyThemeData).
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Временно реализую загрузку данных через свой Loader в надежде потом перейти
  // на что-нибудь посерьёзней.
  @override
  Widget build(BuildContext context) => Loader<Settings>(
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
                  onRepeat: () => Loader.of<Settings>(context).reload(),
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
              // Между этими строками и intl какой-то конфликт.
              // Без них работает. Но пропадает русификация в DatePicker.
              // localizationsDelegates: const [
              //   GlobalMaterialLocalizations.delegate,
              //   GlobalWidgetsLocalizations.delegate,
              //   GlobalCupertinoLocalizations.delegate,
              // ],
              // supportedLocales: const [
              //   Locale('ru'),
              // ],
              home: settings == null
                  ? const SplashScreen()
                  : settings.showTutorial
                      ? OnboardingScreen()
                      : PlaceListScreen(),
            ),
          ),
        ),
      );
}
