part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType()';
}

class FavoriteStarted extends FavoriteEvent {
  const FavoriteStarted();
}

abstract class FavoriteEventWithPlace extends FavoriteEvent {
  const FavoriteEventWithPlace(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];

  @override
  String toString() => '$runtimeType(#${place.id} ${place.name})';
}

class FavoritePlaceRemoved extends FavoriteEventWithPlace {
  const FavoritePlaceRemoved(Place place) : super(place);
}

class FavoritePlaceMoved extends FavoriteEventWithPlace {
  const FavoritePlaceMoved(Place place) : super(place);
}

class FavoritePlaceChanged extends FavoriteEvent {
  const FavoritePlaceChanged(this.notification) : super();

  final PlaceNotification notification;

  @override
  List<Object?> get props => [notification];

  @override
  String toString() => 'FavoritePlaceChanged($notification)';
}
