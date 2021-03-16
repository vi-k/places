part of 'edit_place_bloc.dart';

@immutable
abstract class EditPlaceState extends Equatable {
  const EditPlaceState();

  @override
  List<Object?> get props => [];
}

/// Редактирование.
class EditPlaceEditing extends EditPlaceState {
  const EditPlaceEditing();
}

/// Сохранение.
class EditPlaceLoading extends EditPlaceState {
  const EditPlaceLoading();
}

/// Данные сохранены.
class EditPlaceSaved extends EditPlaceState {
  const EditPlaceSaved(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}
