part of 'places_bloc.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType()';
}

/// Восстановить прошлое состояние или инициализировать.
class PlacesRestoreOrInit extends PlacesEvent {
  const PlacesRestoreOrInit();
}

/// Загрузить список мест.
class PlacesLoad extends PlacesEvent {
  const PlacesLoad(this.filter);

  final Filter filter;

  @override
  List<Object?> get props => [filter];

  @override
  String toString() => 'PlacesLoad($filter)';
}

/// Обновить список мест со старым фильтром.
class PlacesReload extends PlacesEvent {
  const PlacesReload();
}

abstract class PlacesWithPlace extends PlacesEvent {
  const PlacesWithPlace(this.place) : super();

  final Place place;

  @override
  List<Object?> get props => [place];

  @override
  String toString() => '$runtimeType(#${place.id} ${place.name})';
}

/// Удалить карточку.
class PlacesRemovePlace extends PlacesWithPlace {
  const PlacesRemovePlace(Place place) : super(place);
}

/// Сохранить настройки карты.
class PlacesSaveMapSettings extends PlacesEvent {
  const PlacesSaveMapSettings({
    required this.mapSettings,
  });

  final MapSettings mapSettings;

  @override
  List<Object?> get props => [mapSettings];

  @override
  String toString() => 'PlacesSaveMapSettings()';
}

/// Уведомить об изменении места.
class PlacesNotifyPlace extends PlacesEvent {
  const PlacesNotifyPlace(this.notification) : super();

  final PlaceNotification notification;

  @override
  List<Object?> get props => [notification];

  @override
  String toString() => 'PlacesNotifyPlace($notification)';
}
