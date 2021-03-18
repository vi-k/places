import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/model/settings.dart';
import 'package:places/ui/res/themes.dart';

part 'app_event.dart';
part 'app_state.dart';

/// BLoC для инициализации приложения.
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppIniting());

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

    //await Future<void>.delayed(const Duration(milliseconds: 3200));

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
