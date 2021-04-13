part of 'places_bloc.dart';

/// Основное состояние для PlacesBloc.
class PlacesState extends Equatable with BlocValues {
  const PlacesState({
    required this.filter,
    required this.mapSettings,
    required this.places,
  });

  const PlacesState.init()
      : filter = const BlocValue.undefined(),
        mapSettings = const BlocValue.undefined(),
        places = const BlocValue.undefined();

  PlacesState.from(PlacesState state)
      : filter = state.filter,
        places = state.places,
        mapSettings = state.mapSettings;

  final BlocValue<Filter> filter;
  final BlocValue<MapSettings?> mapSettings;
  final BlocValue<List<Place>> places;

  @override
  List<BlocValue> get values => [filter, mapSettings, places];

  @override
  List<Object?> get props => [values];

  PlacesState copyWith({
    BlocValue<Filter>? filter,
    BlocValue<MapSettings?>? mapSettings,
    BlocValue<List<Place>>? places,
  }) =>
      PlacesState(
        filter: filter ?? this.filter,
        mapSettings: mapSettings ?? this.mapSettings,
        places: places ?? this.places,
      );

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType('
      'filter: $filter, '
      'mapSettings: $mapSettings, '
      'places: ${places.isNotReady ? places.state : places.value.length})';
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
