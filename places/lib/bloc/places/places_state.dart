part of 'places_bloc.dart';

/// Состояния для PlacesBloc.
@immutable
abstract class PlacesState extends Equatable {
  const PlacesState(this.filter);

  /// Фильтр - общий для всех состояний.
  final Filter filter;

  @override
  List<Object> get props => [filter];
}

/// Состояние: загрузка данных.
class PlacesLoading extends PlacesState {
  const PlacesLoading(Filter filter) : super(filter);
}

/// Состояние: данные загружены.
class PlacesReady extends PlacesState {
  const PlacesReady(Filter filter, this.places) : super(filter);

  final List<Place> places;

  @override
  List<Object> get props => [places];
}
