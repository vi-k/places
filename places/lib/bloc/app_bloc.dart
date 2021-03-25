import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/model/settings.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/data/repository/key_value_repository/key_value_repository.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/let_and_also.dart';

part 'app_event.dart';
part 'app_state.dart';

/// BLoC для инициализации приложения.
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._storeRepository, this._placeInteractor)
      : super(const AppIniting());

  static const isDarkTag = 'isDark';
  static const showTutorialTag = 'showTutorial';
  static const radiusTag = 'radius';
  static const placeTypesTag = 'placeTypes';

  final PlaceInteractor _placeInteractor;
  final KeyValueRepository _storeRepository;

  late Settings _settings;
  Settings get settings => _settings;

  late MyThemeData _theme;
  MyThemeData get theme => _theme;

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppInit) {
      yield await _init();
    } else if (event is AppChangeSettings) {
      yield await _changeSettings(event);
    }
  }

  // Загрузка настроек.
  Future<Settings> _loadSettings() async {
    final isDark = await _storeRepository.loadBool(isDarkTag) ?? false;
    final showTutorial =
        await _storeRepository.loadBool(showTutorialTag) ?? true;
    final radius =
        await _storeRepository.loadDouble(radiusTag) ?? double.infinity;
    final placeTypes = await _storeRepository.loadStringList(placeTypesTag);

    return Settings(
      isDark: isDark,
      showTutorial: showTutorial,
      filter: Filter(
        radius: Distance(radius),
        placeTypes: placeTypes?.let(placeTypesFromList),
      ),
    );
  }

  // Инициализация приложения.
  Future<AppState> _init() async {
    _settings = await _loadSettings();

    await Future.wait([
      // Загрузка настроек.
      // _loadSettings().then((settings) => _settings = settings),
      // Иммитация инициализации: получение списка мест для тестирования.
      _placeInteractor.getPlaces(Filter()).then((places) {
        for (final place in places) {
          print(place.toString(short: true));
          // print(place.toString());
        }
      }),
      // Выжидаем минимум времени.
      Future<void>.delayed(const Duration(seconds: 4)),
    ]);

    // Инициализация темы.
    _initTheme(_settings.isDark);

    return AppReady();
  }

  void _initTheme(bool isDark) {
    _theme = isDark ? createDarkTheme() : createLightTheme();
  }

  // Изменение настроек.
  Future<AppState> _changeSettings(AppChangeSettings event) async {
    if (event.settings.isDark != _settings.isDark) {
      _initTheme(event.settings.isDark);
    }
    _settings = event.settings;

    await Future.wait([
      _storeRepository.saveBool(isDarkTag, _settings.isDark),
      _storeRepository.saveBool(showTutorialTag, _settings.showTutorial),
      _storeRepository.saveDouble(radiusTag, _settings.filter.radius.value),
      if (_settings.filter.placeTypes == null)
        _storeRepository.remove(placeTypesTag)
      else
        _storeRepository.saveStringList(placeTypesTag,
            _settings.filter.placeTypes!.map((e) => e.name).toList()),
    ]);

    return AppReady();
  }
}
