import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/repository/base/filter.dart';
import 'package:places/utils/distance.dart';

part 'places_event.dart';
part 'places_state.dart';

/// BLoC для списка мест.
class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  PlacesBloc(this._placeInteractor, Filter filter)
      : super(PlacesLoading(filter));

  final PlaceInteractor _placeInteractor;

  @override
  Stream<PlacesState> mapEventToState(
    PlacesEvent event,
  ) async* {
    if (event is PlacesLoad) {
      yield* _reload(event.filter);
    } else if (event is PlacesReload) {
      yield* _reload(state.filter);
    } else if (event is PlacesRemove) {
      yield* _delete(event);
    }
  }

  Stream<PlacesState> _reload(Filter filter) async* {
    yield PlacesLoading(filter);
    final places = await _placeInteractor.getPlaces(filter);
    yield PlacesReady(filter, places);
  }

  Stream<PlacesState> _delete(PlacesRemove event) async* {
    final currentState = state;
    if (currentState is! PlacesReady) {
      throw ArgumentError('PlacesDelete: state must be PlacesReady');
    }

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newPlaces = List<Place>.from(currentState.places)
      ..remove(event.place);
    yield PlacesReady(currentState.filter, newPlaces);
    // TODO: В нормальном случае здесь надо добавить обработку ошибок и при
    // ошибке перезагружать список.
    await _placeInteractor.removePlace(event.place.id);
  }
}
