part of 'place_bloc.dart';

@immutable
abstract class PlaceState extends Equatable {
  const PlaceState(this.place);

  final Place place;

  @override
  List<Object> get props => [place];
}

/// Состояние: данные готовы.
class PlaceReady extends PlaceState {
  const PlaceReady(Place place) : super(place);
}

/// Состояние: обновление.
class PlaceRenewal extends PlaceState {
  PlaceRenewal(PlaceState prevState) : super(prevState.place);
}
