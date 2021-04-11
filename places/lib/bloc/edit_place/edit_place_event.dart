part of 'edit_place_bloc.dart';

abstract class EditPlaceEvent extends Equatable {
  const EditPlaceEvent();

  @override
  List<Object?> get props => [];
}

/// Установить начальные координаты.
class EditPlaceSetLocation extends EditPlaceEvent {
  const EditPlaceSetLocation() : super();
}

/// Загрузить информацию о месте.
class EditPlaceLoad extends EditPlaceEvent {
  const EditPlaceLoad() : super();
}

/// Добавить фотографию.
class EditPlaceAddPhoto extends EditPlaceEvent {
  const EditPlaceAddPhoto(this.photo);

  final Photo photo;

  @override
  List<Object?> get props => [photo];
}

/// Удалить фотографию.
class EditPlaceRemovePhoto extends EditPlaceEvent {
  const EditPlaceRemovePhoto(this.photo);

  final Photo photo;

  @override
  List<Object?> get props => [photo];
}

/// Установить значения полей.
class EditPlaceSetValues extends EditPlaceEvent {
  const EditPlaceSetValues({
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

/// Сохранить результат.
class EditPlaceSave extends EditPlaceEvent {
  const EditPlaceSave();
}
