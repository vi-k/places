import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

/// Базовый класс BLoC'а для избранного.
///
/// Реализации: [WishlistBloc] и [VisitedBloc]
abstract class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc._(this.placeInteractor) : super(WishlistInitial());

  factory WishlistBloc(PlaceInteractor placeInteractor, Favorite listType) =>
      listType == Favorite.wishlist
          ? WishlistWishlistBloc(placeInteractor)
          : WishlistVisitedBloc(placeInteractor);

  final PlaceInteractor placeInteractor;

  Future<List<Place>> _getList();
  Future<Place> _removeFromList(Place place);
  Future<Place> _addToAdjacentList(Place place);

  @override
  Stream<WishlistState> mapEventToState(WishlistEvent event) async* {
    if (event is WishlistLoad) {
      yield* _load(event);
    } else if (event is WishlistRemove) {
      yield* _remove(event);
    } else if (event is WishlistMoveToAdjacentList) {
      yield* _moveToAdjacentList(event);
    }
  }

  Stream<WishlistState> _load(WishlistEvent _) async* {
    yield WishlistLoading();
    final places = await _getList();
    yield WishlistReady(places);
  }

  Stream<WishlistState> _remove(WishlistRemove event) async* {
    final currentState = state as WishlistReady;

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newPlaces = List<Place>.from(currentState.places)
      ..remove(event.place);
    yield WishlistReady(newPlaces);
    // TODO: Добавить обработку ошибок.
    await _removeFromList(event.place);
  }

  Stream<WishlistState> _moveToAdjacentList(
      WishlistMoveToAdjacentList event) async* {
    final currentState = state;
    if (currentState is! WishlistReady) {
      throw ArgumentError('$event: state must be WishlistReady');
    }

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newPlaces = List<Place>.from(currentState.places)
      ..remove(event.place);
    yield WishlistReady(newPlaces);
    // TODO: Добавить обработку ошибок.
    await _removeFromList(event.place);
    await _addToAdjacentList(event.place);
  }
}

class WishlistWishlistBloc extends WishlistBloc {
  WishlistWishlistBloc(PlaceInteractor placeInteractor)
      : super._(placeInteractor);

  @override
  Future<List<Place>> _getList() => placeInteractor.getWishlist();

  @override
  Future<Place> _removeFromList(Place place) =>
      placeInteractor.removeFromWishlist(place);

  @override
  Future<Place> _addToAdjacentList(Place place) =>
      placeInteractor.addToVisited(place);
}

class WishlistVisitedBloc extends WishlistBloc {
  WishlistVisitedBloc(PlaceInteractor placeInteractor)
      : super._(placeInteractor);

  @override
  Future<List<Place>> _getList() => placeInteractor.getVisited();

  @override
  Future<Place> _removeFromList(Place place) =>
      placeInteractor.removeFromVisited(place);

  @override
  Future<Place> _addToAdjacentList(Place place) =>
      placeInteractor.addToWishlist(place);
}
