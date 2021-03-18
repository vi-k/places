part of 'edit_place_bloc.dart';

@immutable
abstract class EditPlaceEvent extends Equatable {
  const EditPlaceEvent(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}

/// Создать место.
class EditPlaceAdd extends EditPlaceEvent {
  const EditPlaceAdd(Place place) : super(place);
}

/// Обновить место.
class EditPlaceUpdate extends EditPlaceEvent {
  const EditPlaceUpdate(Place place) : super(place);
}
