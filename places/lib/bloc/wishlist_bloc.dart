import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_base.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

/// BLoC для избранного.
///
/// Одновременно и для "Хочу посетить" и для "Посетил", т.к. оба списка
/// по функционалу одинаковы.
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(PlaceInteractor placeInteractor, Favorite listType)
      : _getList = listType == Favorite.wishlist
            ? placeInteractor.getWishlist
            : placeInteractor.getVisited,
        _removeFromList = listType == Favorite.wishlist
            ? placeInteractor.removeFromWishlist
            : placeInteractor.removeFromVisited,
        _addToAdjacentList = listType == Favorite.wishlist
            ? placeInteractor.addToVisited
            : placeInteractor.addToWishlist,
        super(WishlistInitial());

  final Future<List<Place>> Function() _getList;
  final Future<Place> Function(PlaceBase place) _removeFromList;
  final Future<Place> Function(PlaceBase place) _addToAdjacentList;

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
