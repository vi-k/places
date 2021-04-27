part of 'place_bloc.dart';

class PlaceState extends Equatable {
  const PlaceState(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}

class PlaceLoadInProgress extends PlaceState {
  PlaceLoadInProgress(PlaceState prevState) : super(prevState.place);
}
