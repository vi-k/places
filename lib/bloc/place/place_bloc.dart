import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_user_info.dart';

part 'place_event.dart';
part 'place_state.dart';

/// BLoC для места.
class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceBloc(this._placeInteractor, Place place) : super(PlaceState(place)) {
    _placeInteractor.stream.listen((notification) {
      if (notification is PlaceNotificationWithPlace &&
          notification.place.id == place.id) {
        add(PlacePlaceChanged(notification.place));
      }
    });
  }

  final PlaceInteractor _placeInteractor;

  @override
  Stream<PlaceState> mapEventToState(
    PlaceEvent event,
  ) async* {
    if (event is PlacePlaceChanged) {
      yield PlaceState(event.place);
    } else if (event is PlaceUserInfoUpdated) {
      yield* _updateUserInfo(event);
    } else if (event is PlaceWishlistToggled) {
      yield* _toggleWishlist(event);
    }
  }

  /// Обновляет пользовательскую информацию о месте.
  Stream<PlaceState> _updateUserInfo(PlaceUserInfoUpdated event) async* {
    yield PlaceLoadInProgress(state);
    final newPlace =
        await _placeInteractor.updateUserInfo(state.place, event.userInfo);
    yield PlaceState(newPlace);
  }

  /// Переключает в "Избранное" и обратно.
  Stream<PlaceState> _toggleWishlist(PlaceWishlistToggled event) async* {
    yield PlaceLoadInProgress(state);
    final newPlace = state.place.userInfo.favorite == Favorite.wishlist
        ? await _placeInteractor.removeFromWishlist(state.place)
        : state.place.userInfo.favorite == Favorite.visited
            ? await _placeInteractor.removeFromVisited(state.place)
            : await _placeInteractor.addToWishlist(state.place);
    yield PlaceState(newPlace);
  }
}
