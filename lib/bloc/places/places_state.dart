part of 'places_bloc.dart';

/// Основное состояние для PlacesBloc.
class PlacesState extends Equatable with BlocValues {
  const PlacesState({
    required this.filter,
    required this.mapSettings,
    required this.places,
    required this.scrollOffset,
  });

  const PlacesState.init()
      : filter = const BlocValue.undefined(),
        mapSettings = const BlocValue.undefined(),
        places = const BlocValue.undefined(),
        scrollOffset = const BlocValue.undefined();

  PlacesState.from(PlacesState state)
      : filter = state.filter,
        mapSettings = state.mapSettings,
        places = state.places,
        scrollOffset = state.scrollOffset;

  final BlocValue<Filter> filter;
  final BlocValue<MapSettings?> mapSettings;
  final BlocValue<List<Place>> places;
  final BlocValue<double> scrollOffset;

  @override
  List<BlocValue> get values => [filter, mapSettings, places, scrollOffset];

  @override
  List<Object?> get props => [values];

  PlacesState copyWith({
    BlocValue<Filter>? filter,
    BlocValue<MapSettings?>? mapSettings,
    BlocValue<List<Place>>? places,
    BlocValue<double>? scrollOffset,
  }) =>
      PlacesState(
        filter: filter ?? this.filter,
        mapSettings: mapSettings ?? this.mapSettings,
        places: places ?? this.places,
        scrollOffset: scrollOffset ?? this.scrollOffset,
      );

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType('
      'filter: $filter, '
      'mapSettings: $mapSettings, '
      'places: ${places.isNotReady ? places.state : places.value.length}, '
      'scrollOffset: $scrollOffset)';
}

/// Загрузка данных.
class PlacesLoading extends PlacesState {
  PlacesLoading(PlacesState state) : super.from(state);
}

/// Ошибка загрузки данных.
class PlacesLoadingFailed extends PlacesState {
  PlacesLoadingFailed(PlacesState state, this.error) : super.from(state);

  final Exception error;

  @override
  List<Object?> get props => [values, error];
}
