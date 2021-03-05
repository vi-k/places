import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_base.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

/// Блок для избранного.
///
/// Одновременно и для "Хочу посетить" и для "Посетил", т.к. оба списка
/// по функционалу одинаковы.
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(this.placeInteractor, Favorite listType)
      : getList = listType == Favorite.wishlist
            ? placeInteractor.getWishlist
            : placeInteractor.getVisited,
        removeFromList = listType == Favorite.wishlist
            ? placeInteractor.removeFromWishlist
            : placeInteractor.removeFromVisited,
        super(WishlistInitial());

  final PlaceInteractor placeInteractor;

  final Future<List<Place>> Function() getList;
  final Future<Place> Function(PlaceBase place) removeFromList;

  @override
  Stream<WishlistState> mapEventToState(WishlistEvent event) async* {
    if (event is WishlistLoad) {
      yield* _load(event);
    } else if (event is WishlistDelete) {
      yield* _delete(event);
    }
  }

  Stream<WishlistState> _load(WishlistEvent event) async* {
    yield WishlistLoading();
    final places = await getList();
    yield WishlistLoaded(places);
  }

  Stream<WishlistState> _delete(WishlistDelete event) async* {
    final currentState = state;
    if (currentState is! WishlistLoaded) {
      yield WishlistLoading();
      await removeFromList(event.place);
      final places = await getList();
      yield WishlistLoaded(places);
    } else {
      // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
      final newPlaces = List<Place>.from(currentState.places)
        ..remove(event.place);
      yield WishlistLoaded(newPlaces);
      // В нормальном случае здесь надо добавить обработку ошибок и при ошибке
      // перезагружать список.
      await removeFromList(event.place);
    }
  }
}
