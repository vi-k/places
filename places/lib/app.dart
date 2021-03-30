import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'bloc/app/app_bloc.dart';
import 'bloc/favorite/favorite_bloc.dart';
import 'bloc/places/places_bloc.dart';
import 'data/interactor/place_interactor.dart';
import 'data/repository/db_repository/db_repository.dart';
import 'data/repository/db_repository/sqlite_db_repository.dart';
import 'data/repository/key_value_repository/key_value_repository.dart';
import 'data/repository/key_value_repository/shared_preferences_repository.dart';
import 'data/repository/location_repository/location_repository.dart';
import 'data/repository/location_repository/real_location_repository.dart';
import 'data/repository/place_repository/api_place_mapper.dart';
import 'data/repository/place_repository/api_place_repository.dart';
import 'data/repository/place_repository/dio_exception.dart';
import 'data/repository/place_repository/place_repository.dart';
import 'ui/screen/onboarding_screen.dart';
import 'ui/screen/place_list_screen.dart';
import 'ui/screen/splash_screen.dart';

/// Основной виджет-приложение.
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

// ignore: prefer_mixin
class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    print('_AppState.dispose()');
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<KeyValueRepository>(
            create: (context) => SharedPreferencesRepository(),
          ),
          Provider<DbRepository>(
            create: (context) => SqliteDbRepository(),
          ),
          Provider<Dio>(
            create: (context) => Dio(BaseOptions(
              baseUrl: 'https://test-backend-flutter.surfstudio.ru',
              connectTimeout: 10000,
              receiveTimeout: 10000,
              sendTimeout: 10000,
              responseType: ResponseType.json,
            ))
              ..interceptors.add(InterceptorsWrapper(
                onError: (error, handler) {
                  final repositoryException = createExceptionFromDio(error);
                  print(repositoryException);
                  handler.next(error);
                },
                onRequest: (options, handler) {
                  print('Выполняется запрос: '
                      '${options.method} ${options.uri}');
                  if (options.data != null) {
                    print('data: ${options.data}');
                  }
                  handler.next(options);
                },
                onResponse: (response, handler) {
                  print('Получен ответ: '
                      '${response.statusMessage} (${response.statusCode})');
                  // print(response.data);
                  handler.next(response);
                },
              )),
          ),
          ProxyProvider<Dio, PlaceRepository>(
            update: (context, dio, previous) =>
                ApiPlaceRepository(dio, ApiPlaceMapper()),
          ),
          Provider<LocationRepository>(
            create: (context) => RealLocationRepository(),
          ),
          ProxyProvider3<PlaceRepository, DbRepository, LocationRepository,
              PlaceInteractor>(
            update: (context, placeRepository, dbRepository, locationRepository,
                    previous) =>
                PlaceInteractor(
              placeRepository: placeRepository,
              dbRepository: dbRepository,
              locationRepository: locationRepository,
            ),
            dispose: (context, interactor) => interactor.close(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
              create: (context) => AppBloc(
                context.read<KeyValueRepository>(),
                context.read<PlaceInteractor>(),
              )..add(const AppInit()),
            ),
            BlocProvider<PlacesBloc>(
              create: (context) => PlacesBloc(
                context.read<PlaceInteractor>(),
                context.read<AppBloc>().settings.filter,
              )..add(const PlacesReload()),
            ),
            BlocProvider<WishlistBloc>(
              create: (context) => WishlistBloc(
                context.read<PlaceInteractor>(),
              )..add(const FavoriteLoad()),
            ),
            BlocProvider<VisitedBloc>(
              create: (context) => VisitedBloc(
                context.read<PlaceInteractor>(),
              )..add(const FavoriteLoad()),
            ),
          ],
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) => MaterialApp(
              key: ValueKey(state is! AppIniting),
              title: 'Places',
              theme: context.watch<AppBloc>().theme.app,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ru'),
              ],
              home: state is AppIniting
                  ? const SplashScreen()
                  : context.watch<AppBloc>().settings.showTutorial
                      ? OnboardingScreen()
                      : PlaceListScreen(),
            ),
          ),
        ),
      );
}
