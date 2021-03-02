import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:places/data/repository/base/location_repository.dart';
import 'package:places/ui/screen/onboarding_screen.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:provider/provider.dart';

import 'data/interactor/place_interactor.dart';
import 'data/interactor/settings_interactor.dart';
import 'data/model/settings.dart';
import 'data/repository/base/mock_location_repository.dart';
import 'data/repository/base/place_repository.dart';
import 'data/repository/mock_place_repository.dart';
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
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<PlaceRepository>(
            create: (_) => MockPlaceRepository(),
          ),
          Provider<LocationRepository>(
            create: (_) => MockLocationRepository(),
          ),
          ProxyProvider2<PlaceRepository, LocationRepository, PlaceInteractor>(
            update: (_, placeRepository, locationRepository, __) =>
                PlaceInteractor(
              placeRepository: placeRepository,
              locationRepository: locationRepository,
            ),
          ),
          Provider<SettingsInteractor>(
            create: (_) => SettingsInteractor(),
          ),
        ],
        builder: (context, _) => Loader<Settings>(
          load: context.read<SettingsInteractor>().loadSettings,
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
            myThemeData:
                (settings?.isDark ?? true) ? myDarkTheme : myLightTheme,
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
        ),
      );
}
