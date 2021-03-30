part of 'favorite_bloc.dart';

/// События для [_FavoriteBloc].
@immutable
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType';
}

/// Событие: загрузить избранное.
class FavoriteLoad extends FavoriteEvent {
  const FavoriteLoad();
}

/// Событие: удалить карточку из избранного.
class FavoriteRemove extends FavoriteEvent {
  const FavoriteRemove(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}

/// Событие: перенести карточку в соседний список.
class FavoriteMoveToAdjacentList extends FavoriteEvent {
  const FavoriteMoveToAdjacentList(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}
