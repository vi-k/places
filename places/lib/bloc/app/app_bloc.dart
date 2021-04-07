import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/bloc/my_bloc.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/data/model/settings.dart';
import 'package:places/data/repositories/key_value/key_value_repository.dart';
import 'package:places/ui/res/themes.dart';

part 'app_event.dart';
part 'app_state.dart';

/// BLoC для инициализации приложения.
class AppBloc extends MyBloc<AppEvent, AppState> {
  AppBloc(this._keyValueRepository)
      : super(const AppIniting());

  static const section = 'App';
  static const isDarkTag = 'isDark';
  static const showTutorialTag = 'showTutorial';

  final KeyValueRepository _keyValueRepository;

  late Settings _settings;
  Settings get settings => _settings;

  late MyThemeData _theme = createLightTheme();
  MyThemeData get theme => _theme;

  // Инициализация приложения.
  @override
  Future<AppState> initBloc() async {
    debugPrint('${DateTime.now()}: AppBloc.initBloc()');
    await Future.wait([
      // Загрузка настроек.
      _loadSettings(),
      // Выжидаем минимум времени.
      Future<void>.delayed(const Duration(seconds: 4)),
    ]);
    debugPrint('${DateTime.now()}: AppBloc.initBloc() 2');

    // Инициализация темы.
    _initTheme(_settings.isDark);

    debugPrint('${DateTime.now()}: AppBloc.initBloc() 3');
    return const AppReady();
  }

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    debugPrint('${DateTime.now()}: AppBloc.mapEventToState() $event');
    if (event is AppChangeSettings) {
      yield* _changeSettings(event);
    }
  }

  // Загрузка настроек.
  Future<void> _loadSettings() async {
    final isDark = await _keyValueRepository.loadBool(section, isDarkTag) ?? false;
    final showTutorial =
        await _keyValueRepository.loadBool(section, showTutorialTag) ?? true;

    _settings = Settings(
      isDark: isDark,
      showTutorial: showTutorial,
    );
  }

  void _initTheme(bool isDark) {
    _theme = isDark ? createDarkTheme() : createLightTheme();
  }

  // Изменение настроек.
  Stream<AppState> _changeSettings(AppChangeSettings event) async* {
    yield const AppChanging();

    final isDark = event.isDark;
    if (isDark != null && isDark != _settings.isDark) {
      _initTheme(isDark);
    }

    _settings = _settings.copyWith(
      isDark: event.isDark,
      showTutorial: event.showTutorial,
    );

    // Сохраняем настройки.
    await Future.wait([
      _keyValueRepository.saveBool(section, isDarkTag, _settings.isDark),
      _keyValueRepository.saveBool(
          section, showTutorialTag, _settings.showTutorial),
    ]);

    yield const AppReady();
  }
}
