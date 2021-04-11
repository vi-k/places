part of 'favorite_bloc.dart';

/// Основное состояние для FavoriteBloc.
class FavoriteState extends Equatable with BlocValues {
  const FavoriteState({
    required this.places,
  });

  const FavoriteState.init()
      : places = const BlocValue.undefined();

  FavoriteState.from(FavoriteState state)
      : places = state.places;

  final BlocValue<List<Place>> places;

  @override
  List<BlocValue> get values => [places];

  @override
  List<Object?> get props => [values];

  FavoriteState copyWith({
    BlocValue<List<Place>>? places,
  }) =>
      FavoriteState(
        places: places ?? this.places,
      );

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType('
      'places: ${places.isNotReady ? places.state : places.value.length})';
}

/// Загрузка данных.
class FavoriteLoading extends FavoriteState {
  FavoriteLoading(FavoriteState state) : super.from(state);
}

/// Ошибка загрузки данных.
class FavoriteLoadingFailed extends FavoriteState {
  FavoriteLoadingFailed(FavoriteState state, this.error) : super.from(state);

  final Exception error;

  @override
  List<Object?> get props => [values, error];

  @override
  // ignore: no_runtimetype_tostring
  String toString() => 'FavoriteLoadingFailed($error)';
}
