part of 'place_bloc.dart';

abstract class PlaceState extends Equatable {
  const PlaceState(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}

/// Загрузка/обновление.
class PlaceLoading extends PlaceState {
  PlaceLoading(PlaceState prevState) : super(prevState.place);
}

/// Данные готовы.
class PlaceReady extends PlaceState {
  const PlaceReady(Place place) : super(place);
}
