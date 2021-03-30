import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';

part 'wishlist_bloc.dart';
part 'visited_bloc.dart';
part 'favorite_event.dart';
part 'favorite_state.dart';

/// Базовый класс BLoC'а для избранного.
///
/// Реализации: [WishlistBloc] и [VisitedBloc]
abstract class _FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  _FavoriteBloc._(this._placeInteractor) : super(const FavoriteLoading()) {
    _placeInteractor.stream.listen(_onEvent);
  }

  final PlaceInteractor _placeInteractor;

  Future<List<Place>> _getList();
  Future<Place> _removeFromList(Place place);
  Future<Place> _addToAdjacentList(Place place);

  @mustCallSuper
  bool _onEvent(Place place) {
    final currentState = state;
    if (currentState is FavoriteReady) {
      final index = currentState.places.indexWhere((e) => e.id == place.id);
      if (index == -1) return false;

      currentState.places[index] = place;
      emit(FavoriteReady(currentState.places));
    }

    return true;
  }

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteLoad) {
      yield* _load(event);
    } else if (event is FavoriteRemove) {
      yield* _remove(event);
    } else if (event is FavoriteMoveToAdjacentList) {
      yield* _moveToAdjacentList(event);
    }
  }

  Stream<FavoriteState> _load(FavoriteEvent _) async* {
    yield const FavoriteLoading();
    final places = await _getList();
    yield FavoriteReady(places);
  }

  Stream<FavoriteState> _remove(FavoriteRemove event) async* {
    final currentState = state as FavoriteReady;

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newPlaces = List<Place>.from(currentState.places)
      ..remove(event.place);
    yield FavoriteReady(newPlaces);
    // TODO: Добавить обработку ошибок.
    await _removeFromList(event.place);
  }

  Stream<FavoriteState> _moveToAdjacentList(
      FavoriteMoveToAdjacentList event) async* {
    final currentState = state;
    if (currentState is! FavoriteReady) {
      throw ArgumentError('$event: state must be WishlistReady');
    }

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newPlaces = List<Place>.from(currentState.places)
      ..remove(event.place);
    yield FavoriteReady(newPlaces);
    // TODO: Добавить обработку ошибок.
    await _removeFromList(event.place);
    await _addToAdjacentList(event.place);
  }
}
