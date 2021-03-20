import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_user_info.dart';

part 'place_event.dart';
part 'place_state.dart';

/// BLoC для места.
class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceBloc(this._placeInteractor, Place place) : super(PlaceReady(place));

  final PlaceInteractor _placeInteractor;

  @override
  Stream<PlaceState> mapEventToState(
    PlaceEvent event,
  ) async* {
    if (event is PlaceChanged) {
      yield* _changed(event);
    } else if (event is PlaceUpdate) {
      yield* _updatePlace(event);
    } else if (event is PlaceUpdateUserInfo) {
      yield* _updateUserInfo(event);
    } else if (event is PlaceToggleWishlist) {
      yield* _toggleWishlist(event);
    }
  }

  Stream<PlaceState> _changed(PlaceChanged event) async* {
    yield PlaceReady(event.place);
  }

  Stream<PlaceState> _updatePlace(PlaceUpdate event) async* {
    yield PlaceLoading(state);
    await _placeInteractor.updatePlace(event.place);
    yield PlaceReady(event.place);
  }

  Stream<PlaceState> _updateUserInfo(PlaceUpdateUserInfo event) async* {
    final currentState = state as PlaceReady;

    yield PlaceLoading(state);
    final newPlace = await _placeInteractor.updateUserInfo(
        currentState.place, event.userInfo);
    yield PlaceReady(newPlace);
  }

  Stream<PlaceState> _toggleWishlist(PlaceToggleWishlist event) async* {
    final currentState = state as PlaceReady;

    yield PlaceLoading(state);
    final newPlace = currentState.place.userInfo.favorite == Favorite.wishlist
        ? await _placeInteractor.removeFromWishlist(currentState.place)
        : currentState.place.userInfo.favorite == Favorite.visited
            ? await _placeInteractor.removeFromVisited(currentState.place)
            : await _placeInteractor.addToWishlist(currentState.place);
    yield PlaceReady(newPlace);
  }
}
