part of 'favorite_bloc.dart';

/// Состояния для WishlistBloc.
@immutable
abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

/// Состояние: загрузка данных.
class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}

/// Состояние: нестабильное, требуется перезагрузка данных.
class FavoriteUnstable extends FavoriteState {
  const FavoriteUnstable();
}

/// Состояние: данные загружены.
class FavoriteReady extends FavoriteState {
  const FavoriteReady(this.places);

  final List<Place> places;

  @override
  List<Object?> get props => [places];
}
