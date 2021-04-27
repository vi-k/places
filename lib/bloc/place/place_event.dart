part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType()';
}

abstract class PlaceEventWithPlace extends PlaceEvent {
  const PlaceEventWithPlace(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];

  @override
  String toString() => '$runtimeType($place)';
}

class PlaceUserInfoUpdated extends PlaceEvent {
  const PlaceUserInfoUpdated(this.userInfo);

  final PlaceUserInfo userInfo;

  @override
  List<Object?> get props => [userInfo];

  @override
  String toString() => 'PlaceUserInfoUpdated($userInfo)';
}

class PlaceWishlistToggled extends PlaceEvent {
  const PlaceWishlistToggled();
}

class PlacePlaceChanged extends PlaceEventWithPlace {
  const PlacePlaceChanged(Place place) : super(place);
}
