import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/bloc/app/app_settings.dart';
import 'package:places/bloc/bloc_values.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/data/repositories/key_value/key_value_repository.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/themes.dart';

part 'app_event.dart';
part 'app_state.dart';

/// BLoC для инициализации приложения.
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._keyValueRepository) : super(const AppState.init());

  static const _section = 'App';
  static const _settingsTag = 'settings';

  final KeyValueRepository _keyValueRepository;

  late MyThemeData _theme = createDarkTheme();
  MyThemeData get theme => _theme;

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _restoreApp();
    } else if (event is AppSettingsChanged) {
      yield* _changeSettings(event);
    }
  }

  // Восстанавливает общее состояние приложения.
  Stream<AppState> _restoreApp() async* {
    var settings = const AppSettings.init();

    await Future.wait([
      // Загружаем настройки.
      _keyValueRepository.loadString(_section, _settingsTag).then((json) {
        if (json != null) {
          settings = AppSettings.parseJson(json);
        }
      }),
      // Выжидаем минимум времени.
      Future<void>.delayed(const Duration(seconds: 4)),
    ]);

    // Инициализируем тему.
    _updateTheme(settings.isDark);

    // Меняем стандартную длительность анимации.
    standartAnimationDuration =
        Duration(milliseconds: settings.animationDuration);

    yield state.copyWith(settings: BlocValue(settings));
  }

  // Обновляет тему.
  void _updateTheme(bool isDark) {
    _theme = isDark ? createDarkTheme() : createLightTheme();
  }

  // Изменяет и сохраняет настройки.
  Stream<AppState> _changeSettings(AppSettingsChanged event) async* {
    if (state.settings.isNotReady) {
      throw StateError('AppBloc: The state not initalized. '
          'Dispatch an [AppStarted] event.');
    }

    final isDark = event.isDark;
    if (isDark != null && isDark != state.settings.value.isDark) {
      _updateTheme(isDark);
    }

    final animationDuration = event.animationDuration;
    if (animationDuration != null) {
      standartAnimationDuration = Duration(milliseconds: animationDuration);
    }

    // Меняем состояние.
    final newSettings = state.settings.value.copyWith(
      isDark: isDark,
      showTutorial: event.showTutorial,
      animationDuration: animationDuration,
    );
    yield state.copyWith(settings: BlocValue(newSettings));

    // Сохраняем настройки (ради пользователя делаем это после изменения
    // состояния).
    final json = newSettings.jsonStringify();
    await _keyValueRepository.saveString(_section, _settingsTag, json);
  }
}
