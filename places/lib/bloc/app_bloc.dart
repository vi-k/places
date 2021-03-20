import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/model/settings.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/data/repository/base/store_repository.dart';
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
  final StoreRepository _storeRepository;

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
  Stream<AppState> _init() async* {
    await Future.wait([
      // Загрузка настроек.
      Future(() async {
        _settings = await _loadSettings();
      }),
      // Иммитация инициализации: получение списка мест для тестирования.
      Future(() async {
        final places = await _placeInteractor.getPlaces(Filter());
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

    yield AppReady();
  }

  void _initTheme(bool isDark) {
    _theme = isDark ? createDarkTheme() : createLightTheme();
  }

  // Изменение настроек.
  Stream<AppState> _changeSettings(AppChangeSettings event) async* {
    final isDark = event.settings.isDark;
    if (isDark != _settings.isDark) {
      await _storeRepository.saveBool(isDarkTag, isDark);
      _initTheme(isDark);
    }

    final showTutorial = event.settings.showTutorial;
    if (showTutorial != _settings.showTutorial) {
      await _storeRepository.saveBool(showTutorialTag, showTutorial);
    }

    final filter = event.settings.filter;
    if (filter != _settings.filter) {
      await _storeRepository.saveDouble(radiusTag, filter.radius.value);
      if (filter.placeTypes == null) {
        await _storeRepository.remove(placeTypesTag);
      } else {
        await _storeRepository.saveStringList(
            placeTypesTag, filter.placeTypes!.map((e) => e.name).toList());
      }
    }

    _settings = event.settings;

    yield AppReady();
  }
}
