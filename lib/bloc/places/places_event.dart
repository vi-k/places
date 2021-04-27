part of 'places_bloc.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType()';
}

class PlacesStarted extends PlacesEvent {
  const PlacesStarted();
}

class PlacesFilterChanged extends PlacesEvent {
  const PlacesFilterChanged(this.filter);

  final Filter filter;

  @override
  List<Object?> get props => [filter];

  @override
  String toString() => 'PlacesFilterChanged($filter)';
}

class PlacesRerfreshed extends PlacesEvent {
  const PlacesRerfreshed();
}

abstract class PlacesWithPlace extends PlacesEvent {
  const PlacesWithPlace(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];

  @override
  String toString() => '$runtimeType(#${place.id} ${place.name})';
}

class PlacesPlaceRemoved extends PlacesWithPlace {
  const PlacesPlaceRemoved(Place place) : super(place);
}

class PlacesMapChanged extends PlacesEvent {
  const PlacesMapChanged(this.mapSettings);

  final MapSettings mapSettings;

  @override
  List<Object?> get props => [mapSettings];

  @override
  String toString() => 'PlacesMapSettingsChanged()';
}

class PlacesScrollChanged extends PlacesEvent {
  const PlacesScrollChanged(this.scrollOffset);

  final double scrollOffset;

  @override
  List<Object?> get props => [scrollOffset];

  @override
  String toString() => 'PlacesScrollChanged($scrollOffset)';
}

class PlacesPlaceChanged extends PlacesEvent {
  const PlacesPlaceChanged(this.notification);

  final PlaceNotification notification;

  @override
  List<Object?> get props => [notification];

  @override
  String toString() => 'PlacesPlaceChanged($notification)';
}
