import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/bloc/bloc_values.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/data/model/map_settings.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repositories/key_value/key_value_repository.dart';
import 'package:places/data/repositories/place/repository_exception.dart';
import 'package:rxdart/rxdart.dart';

part 'places_event.dart';
part 'places_state.dart';

/// BLoC для списка мест.
class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  PlacesBloc(
    this._keyValueRepository,
    this._placeInteractor,
  ) : super(const PlacesState.init()) {
    // Подписываемся на уведомления об изменении мест.
    _placeInteractorSubscription =
        _placeInteractor.stream.listen((notification) {
      add(PlacesPlaceChanged(notification));
    });
  }

  static const _section = 'Places';
  static const _filterTag = 'filter';
  static const _mapSettingsTag = 'mapSettings';
  static const _scrollOffsetTag = 'scrollOffset';

  final KeyValueRepository _keyValueRepository;
  final PlaceInteractor _placeInteractor;
  late final StreamSubscription<PlaceNotification> _placeInteractorSubscription;

  @override
  Future<void> close() async {
    await _placeInteractorSubscription.cancel();

    return super.close();
  }

  bool isDebouncedEvent(PlacesEvent event) => event is PlacesScrollChanged;
  bool isNotDebouncedEvent(PlacesEvent event) => !isDebouncedEvent(event);

  /// События скролла пропускаем через debounce.
  @override
  Stream<Transition<PlacesEvent, PlacesState>> transformEvents(
    Stream<PlacesEvent> events,
    TransitionFunction<PlacesEvent, PlacesState> transitionFn,
  ) =>
      MergeStream<PlacesEvent>([
        events
            .where(isDebouncedEvent)
            .debounceTime(const Duration(milliseconds: 500)),
        events.where(isNotDebouncedEvent),
      ]).asyncExpand(transitionFn);

  @override
  Stream<PlacesState> mapEventToState(
    PlacesEvent event,
  ) async* {
    print(event);
    if (event is PlacesStarted) {
      yield* _restore();
    } else if (event is PlacesFilterChanged) {
      yield* _load(event.filter);
    } else if (event is PlacesRerfreshed) {
      _checkFilter();
      yield* _load(state.filter.value);
    } else if (event is PlacesPlaceRemoved) {
      yield* _removePlace(event);
    } else if (event is PlacesMapChanged) {
      yield* _saveMapSettings(event);
    } else if (event is PlacesScrollChanged) {
      yield* _saveScrollOffset(event);
    } else if (event is PlacesPlaceChanged) {
      yield* _updatePlace(event);
    }
  }

  // Проверяет, установлен ли фильтр.
  void _checkFilter() {
    if (state.filter.isNotReady) {
      throw StateError('PlacesBloc: The state not initalized. '
          'Dispatch a [PlacesStarted] event.');
    }
  }

  // Проверяет, загружены ли места.
  void _checkPlaces() {
    if (state.places.isNotReady) {
      throw StateError('PlacesBloc: The places not loaded. '
          'Dispatch [PlacesRerfreshed] or [PlacesFilterChanged] events.');
    }
  }

  // Восстанавливает прошлое состояние или инициализирует.
  Stream<PlacesState> _restore() async* {
    final filterJson =
        await _keyValueRepository.loadString(_section, _filterTag);
    final filter = filterJson == null ? Filter() : Filter.parseJson(filterJson);

    final mapSettingsJson =
        await _keyValueRepository.loadString(_section, _mapSettingsTag);
    final mapSettings =
        mapSettingsJson == null ? null : MapSettings.parseJson(mapSettingsJson);

    final scrollOffset =
        await _keyValueRepository.loadDouble(_section, _scrollOffsetTag) ?? 0;

    yield state.copyWith(
      filter: BlocValue(filter),
      mapSettings: BlocValue(mapSettings),
      scrollOffset: BlocValue(scrollOffset),
    );

    add(const PlacesRerfreshed());
  }

  // Загружает список мест.
  Stream<PlacesState> _load(Filter filter) async* {
    final saveFuture = _saveFilter(filter);
    final stateWithNewFilter = state.copyWith(filter: BlocValue(filter));
    yield PlacesLoadInProgress(stateWithNewFilter);
    try {
      final places = await _placeInteractor.getPlaces(filter);
      yield stateWithNewFilter.copyWith(places: BlocValue(places));
    } on RepositoryException catch (e) {
      yield PlacesLoadFailure(state, e);
    }
    await saveFuture;
  }

  // Сохраняет фильтр.
  Future<void> _saveFilter(Filter filter) async {
    final json = filter.jsonStringify();
    await _keyValueRepository.saveString(_section, _filterTag, json);
  }

  // Удяляет место из списка.
  Stream<PlacesState> _removePlace(PlacesPlaceRemoved event) async* {
    _checkPlaces();

    // Чтобы пользователь не ждал, удаляем вручную из списка.
    final newPlaces = List<Place>.from(state.places.value)..remove(event.place);
    yield state.copyWith(places: BlocValue(newPlaces));

    // Потом удаляем из хранилища.
    try {
      await _placeInteractor.removePlace(event.place.id);
    } on RepositoryException catch (e) {
      yield PlacesLoadFailure(state, e);
    }
  }

  // Сохраняет настройки карты.
  Stream<PlacesState> _saveMapSettings(PlacesMapChanged event) async* {
    final json = event.mapSettings.jsonStringify();
    await _keyValueRepository.saveString(_section, _mapSettingsTag, json);
    yield state.copyWith(mapSettings: BlocValue(event.mapSettings));
  }

  // Сохраняет позицию скролла.
  Stream<PlacesState> _saveScrollOffset(PlacesScrollChanged event) async* {
    await _keyValueRepository.saveDouble(
      _section,
      _scrollOffsetTag,
      event.scrollOffset,
    );
    yield state.copyWith(scrollOffset: BlocValue(event.scrollOffset));
  }

  // Обновляет место.
  Stream<PlacesState> _updatePlace(PlacesPlaceChanged event) async* {
    if (state.places.isNotReady) return;

    final notification = event.notification;
    if (notification is PlaceNotificationWithPlace) {
      final place = notification.place;
      final places = state.places.value;
      final index = places.indexWhere((e) => e.id == place.id);
      if (index != -1) {
        final newPlaces = List<Place>.from(places);
        newPlaces[index] = place;
        yield state.copyWith(places: BlocValue(newPlaces));
      } else if (notification is PlaceAdded) {
        final newPlaces = List<Place>.from(places)..insert(0, place);
        yield state.copyWith(places: BlocValue(newPlaces));
      }
    } else if (notification is PlaceRemoved) {
      final placeId = notification.placeId;
      final places = state.places.value;
      final index = places.indexWhere((e) => e.id == placeId);
      if (index != -1) {
        final newPlaces = List<Place>.from(places)..removeAt(index);
        yield state.copyWith(places: BlocValue(newPlaces));
      }
    }
  }
}
