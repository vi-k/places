part of 'edit_place_bloc.dart';

abstract class EditPlaceEvent extends Equatable {
  const EditPlaceEvent();

  @override
  List<Object?> get props => [];
}

class EditPlaceStarted extends EditPlaceEvent {
  const EditPlaceStarted() : super();
}

class EditPlaceSetLocation extends EditPlaceEvent {
  const EditPlaceSetLocation() : super();
}

class EditPlacePhotoAdded extends EditPlaceEvent {
  const EditPlacePhotoAdded(this.photo);

  final Photo photo;

  @override
  List<Object?> get props => [photo];
}

class EditPlacePhotoRemoved extends EditPlaceEvent {
  const EditPlacePhotoRemoved(this.photo);

  final Photo photo;

  @override
  List<Object?> get props => [photo];
}

class EditPlaceChanged extends EditPlaceEvent {
  const EditPlaceChanged({
    this.name,
    this.type,
    this.coord,
    this.lat,
    this.lon,
    this.description,
  });

  final String? name;
  final PlaceType? type;
  final Coord? coord;
  final String? lat;
  final String? lon;
  final String? description;

  @override
  List<Object?> get props => [name, type, coord, lat, lon, description];
}

class EditPlaceFinished extends EditPlaceEvent {
  const EditPlaceFinished();
}
