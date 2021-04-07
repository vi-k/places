part of 'places_bloc.dart';

@immutable
class PlacesState extends Equatable {
  const PlacesState({
    required this.filter,
    required this.places,
    required this.mapSettings,
  });

  const PlacesState.init()
      : filter = null,
        places = null,
        mapSettings = null;

  PlacesState.from(PlacesState state)
      : filter = state.filter,
        places = state.places,
        mapSettings = state.mapSettings;

  final Filter? filter;
  final List<Place>? places;
  final MapSettings? mapSettings;

  @override
  List<Object?> get props => [filter, places, mapSettings];

  PlacesState copyWith({
    Filter? filter,
    List<Place>? places,
    MapSettings? mapSettings,
  }) =>
      PlacesState(
        filter: filter ?? this.filter,
        places: places ?? this.places,
        mapSettings: mapSettings ?? this.mapSettings,
      );

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType:\n'
      '    filter: $filter\n'
      '    places: ${places == null ? '-' : places!.length}\n'
      '    mapSettings: $mapSettings';
}

/// Состояние: загрузка данных.
class PlacesLoading extends PlacesState {
  PlacesLoading(PlacesState state) : super.from(state);
}

/// Состояние: загрузка данных.
class PlacesLoadingFailed extends PlacesState {
  PlacesLoadingFailed(PlacesState state, this.error) : super.from(state);

  final Exception error;

  @override
  List<Object?> get props => [filter, places, mapSettings, error];
}
