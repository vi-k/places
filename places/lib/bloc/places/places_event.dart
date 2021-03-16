part of 'places_bloc.dart';

/// События для PlacesBloc.
@immutable
abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object> get props => [];
}

/// Событие: загрузить список мест.
class PlacesLoad extends PlacesEvent {
  const PlacesLoad(this.filter);

  final Filter filter;

  @override
  List<Object> get props => [filter];
}

/// Событие: обновить список мест со старым фильтром.
class PlacesReload extends PlacesEvent {
  const PlacesReload();
}

/// Событие: удалить карточку.
class PlacesRemove extends PlacesEvent {
  const PlacesRemove(this.place);

  final Place place;

  @override
  List<Object> get props => [place];
}
