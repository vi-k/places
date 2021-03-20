import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/settings.dart';
import 'package:places/data/repository/base/filter.dart';
import 'package:places/ui/res/themes.dart';

part 'app_event.dart';
part 'app_state.dart';

/// BLoC для инициализации приложения.
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._placeInteractor) : super(const AppIniting());

  final PlaceInteractor _placeInteractor;

  late Settings _settings;
  Settings get settings => _settings;

  late MyThemeData _theme;
  MyThemeData get theme => _theme;

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppInit) {
      yield* _init();
    } else if (event is AppChangeSettings) {
      yield* _changeSettings(event);
    }
  }

  // Инициализация приложения.
  Stream<AppState> _init() async* {
    // Загрузка настроек.
    _settings = const Settings(isDark: true, showTutorial: true);

    // Инициализация темы.
    _initTheme(settings.isDark);

    // Иммитация инициализации: получаем список мест для тестирования.
    await Future.wait([
      Future(() async {
        final places = await _placeInteractor.getPlaces(Filter());
        for (final place in places) {
          print(place.toString(short: true));
          // print(place.toString());
        }
      }),
      Future<void>.delayed(const Duration(seconds: 4)),
    ]);

    yield AppReady();
  }

  void _initTheme(bool isDark) {
    _theme = isDark ? createDarkTheme() : createLightTheme();
  }

  // Изменение настроек.
  Stream<AppState> _changeSettings(AppChangeSettings event) async* {
    if (event.settings.isDark != _settings.isDark) {
      _initTheme(event.settings.isDark);
    }

    _settings = event.settings;

    yield AppReady();
  }
}
