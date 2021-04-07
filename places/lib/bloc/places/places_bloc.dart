import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/bloc/my_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/data/model/map_settings.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repositories/key_value/key_value_repository.dart';
import 'package:places/data/repositories/place/repository_exception.dart';

part 'places_event.dart';
part 'places_state.dart';

/// BLoC для списка мест.
class PlacesBloc extends MyBloc<PlacesEvent, PlacesState> {
  PlacesBloc(
    this._keyValueRepository,
    this._placeInteractor,
  ) : super(const PlacesState.init()) {
    add(const PlacesInit());
    add(const PlacesReload());

    _placeInteractor.stream.listen((place) {
      final places = state.places;
      if (places != null) {
        final index = places.indexWhere((e) => e.id == place.id);
        if (index != -1) {
          places[index] = place;
          emit(state.copyWith(places: places));
        }
      }
    });
  }

  static const section = 'Places';
  static const filterTag = 'filter';
  static const mapSettingsTag = 'mapSettings';

  final KeyValueRepository _keyValueRepository;
  final PlaceInteractor _placeInteractor;

  @override
  Future<void> close() {
    print('PlacesBloc.close()');
    return super.close();
  }

  // Инициализация блока (восстановление данных).
  @override
  Future<PlacesState> initBloc() async {
    Filter? filter;
    final filterJson = await _keyValueRepository.loadString(section, filterTag);
    if (filterJson != null) {
      filter = Filter.parseJson(filterJson);
    } else {
      filter = Filter();
    }

    // final radius = await _keyValueRepository.loadDouble(section, radiusTag) ??
    //     double.infinity;
    // final placeTypes =
    //     await _keyValueRepository.loadStringList(section, placeTypesTag);
    // final filter = Filter(
    //   radius: Distance(radius),
    //   placeTypes: placeTypes?.let(placeTypesFromList),
    // );

    MapSettings? mapSettings;
    final mapSettingsJson =
        await _keyValueRepository.loadString(section, mapSettingsTag);
    if (mapSettingsJson != null) {
      mapSettings = MapSettings.parseJson(mapSettingsJson);
    }

    add(const PlacesReload());

    return state.copyWith(filter: filter, mapSettings: mapSettings);
  }

  @override
  Stream<PlacesState> mapEventToState(
    PlacesEvent event,
  ) async* {
    if (event is PlacesLoad) {
      yield* _load(event.filter);
    } else if (event is PlacesReload && state.filter != null) {
      yield* _load(state.filter!);
    } else if (event is PlacesRemove) {
      yield* _removePlace(event);
    } else if (event is PlacesSaveMapSettings) {
      yield* _saveMapSettings(event);
    }
  }

  // Загрузка списка мест.
  Stream<PlacesState> _load(Filter filter) async* {
    final saveFuture = _saveFilter(filter);
    yield PlacesLoading(state.copyWith(filter: filter));
    final places = await _placeInteractor.getPlaces(filter);
    yield state.copyWith(places: places);
    await saveFuture;
  }

  Future<void> _saveFilter(Filter filter) async {
    final json = filter.jsonStringify();
    await _keyValueRepository.saveString(section, filterTag, json);
  }

  Stream<PlacesState> _saveMapSettings(PlacesSaveMapSettings event) async* {
    final json = event.mapSettings.jsonStringify();
    await _keyValueRepository.saveString(section, mapSettingsTag, json);

    yield state.copyWith(mapSettings: event.mapSettings);
  }

  Stream<PlacesState> _removePlace(PlacesRemove event) async* {
    final places = state.places;
    if (places != null) {
      // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
      final newPlaces = List<Place>.from(places)..remove(event.place);
      yield state.copyWith(places: newPlaces);
      try {
        await _placeInteractor.removePlace(event.place.id);
      } on RepositoryException catch (e) {
        yield PlacesLoadingFailed(state, e);
      }
    }
  }
}
