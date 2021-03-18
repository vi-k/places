part of 'wishlist_bloc.dart';

/// События для WishlistBloc.
@immutable
abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType';
}

/// Событие: загрузить избранное.
class WishlistLoad extends WishlistEvent {}

/// Событие: удалить карточку из избранного
class WishlistRemove extends WishlistEvent {
  const WishlistRemove(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}

/// Событие: удалить карточку из избранного
class WishlistMoveToAdjacentList extends WishlistEvent {
  const WishlistMoveToAdjacentList(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];
}
