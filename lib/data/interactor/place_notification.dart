part of 'place_interactor.dart';

abstract class PlaceNotification extends Equatable {
  const PlaceNotification();

  @override
  List<Object?> get props => [];
}

abstract class PlaceNotificationWithPlace extends PlaceNotification {
  const PlaceNotificationWithPlace(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];

  @override
  String toString() => '$runtimeType(#${place.id} ${place.name})';
}

/// Добавлено место.
class PlaceAdded extends PlaceNotificationWithPlace {
  const PlaceAdded(Place place) : super(place);
}

/// Место измененено.
class PlaceChanged extends PlaceNotificationWithPlace {
  const PlaceChanged(Place place) : super(place);
}

/// Место удалено.
class PlaceRemoved extends PlaceNotification {
  const PlaceRemoved(this.placeId) : super();

  final int placeId;

  @override
  String toString() => 'PlaceRemoved(#$placeId)';
}
