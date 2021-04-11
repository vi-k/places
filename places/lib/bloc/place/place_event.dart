part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object?> get props => [];
}

abstract class PlaceEventWithPlace extends PlaceEvent {
  const PlaceEventWithPlace(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}

// /// Обновить место.
// class PlaceChanged extends PlaceEventWithPlace {
//   const PlaceChanged(Place place) : super(place);
// }

// /// Обновить место.
// class PlaceUpdate extends PlaceEventWithPlace {
//   const PlaceUpdate(Place place) : super(place);
// }

/// Обновить пользовательскую информацию.
class PlaceUpdateUserInfo extends PlaceEvent {
  const PlaceUpdateUserInfo(this.userInfo);

  final PlaceUserInfo userInfo;

  @override
  List<Object?> get props => [userInfo];
}

/// Переключить в избранное и обратно.
class PlaceToggleWishlist extends PlaceEvent {
  const PlaceToggleWishlist();
}
