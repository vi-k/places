import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:places/data/repositories/place/dio_config.dart';
import 'package:provider/provider.dart';

import 'bloc/app/app_bloc.dart';
import 'bloc/favorite/favorite_bloc.dart';
import 'bloc/places/places_bloc.dart';
import 'data/interactor/place_interactor.dart';
import 'data/repositories/db/db_repository.dart';
import 'data/repositories/db/mock_db_repository.dart';
import 'data/repositories/db/sqlite_db_repository.dart';
import 'data/repositories/key_value/key_value_repository.dart';
import 'data/repositories/key_value/mock_key_value_repository.dart';
import 'data/repositories/key_value/shared_preferences_repository.dart';
import 'data/repositories/location/location_repository.dart';
import 'data/repositories/location/real_location_repository.dart';
import 'data/repositories/place/api_place_mapper.dart';
import 'data/repositories/place/api_place_repository.dart';
import 'data/repositories/place/mock_place_repository.dart';
import 'data/repositories/place/place_repository.dart';
import 'data/repositories/upload/api_upload_repository.dart';
import 'data/repositories/upload/mock_upload_repository.dart';
import 'data/repositories/upload/upload_repository.dart';
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
          Provider<Dio>(
            create: (context) => createDio(createDioOptions()),
          ),
          Provider<KeyValueRepository>(
            create: (context) => SharedPreferencesRepository(),
          ),
          Provider<DbRepository>(
            create: (context) => SqliteDbRepository(),
          ),
          ProxyProvider<Dio, UploadRepository>(
            update: (context, dio, previous) => ApiUploadRepository(dio),
          ),
          ProxyProvider<Dio, PlaceRepository>(
            update: (context, dio, previous) =>
                ApiPlaceRepository(dio, ApiPlaceMapper()),
          ),
          // Provider<KeyValueRepository>(
          //   create: (context) => MockKeyValueRepository(),
          // ),
          // Provider<DbRepository>(
          //   create: (context) => MockDbRepository(),
          // ),
          // Provider<PlaceRepository>(
          //   create: (context) =>
          //       MockPlaceRepository(),
          // ),
          // Provider<UploadRepository>(
          //   create: (context) => const MockUploadRepository(),
          // ),
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
