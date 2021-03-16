import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_user_info.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  PlaceBloc(this._placeInteractor, Place place) : super(PlaceReady(place));

  final PlaceInteractor _placeInteractor;

  @override
  Stream<PlaceState> mapEventToState(
    PlaceEvent event,
  ) async* {
    if (event is PlaceUpdate) {
      yield* _update(event);
    } else if (event is PlaceToggleWishlist) {
      yield* _toggleWishlist(event);
    } else if (event is PlaceUpdateUserInfo) {
      yield* _updateUserInfo(event);
    }
  }

  Stream<PlaceState> _update(PlaceUpdate event) async* {
    yield PlaceReady(event.place);
  }

  Stream<PlaceState> _toggleWishlist(PlaceToggleWishlist event) async* {
    yield PlaceRenewal(state);
    final newPlace = await _placeInteractor.toggleWishlist(state.place);
    yield PlaceReady(newPlace);
  }

  Stream<PlaceState> _updateUserInfo(PlaceUpdateUserInfo event) async* {
    yield PlaceRenewal(state);
    final newPlace =
        await _placeInteractor.updateUserInfo(state.place, event.userInfo);
    yield PlaceReady(newPlace);
  }
}
