part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType()';
}

/// Загрузить избранное.
class FavoriteLoad extends FavoriteEvent {
  const FavoriteLoad();
}

abstract class FavoriteEventWithPlace extends FavoriteEvent {
  const FavoriteEventWithPlace(this.place);

  final Place place;

  @override
  List<Object?> get props => [place];

  @override
  String toString() => '$runtimeType(${place.id} ${place.name})';
}

/// Удалить карточку из избранного.
class FavoriteRemovePlace extends FavoriteEventWithPlace {
  const FavoriteRemovePlace(Place place) : super(place);
}

/// Перенести карточку в соседний список.
class FavoriteMoveToAdjacentList extends FavoriteEventWithPlace {
  const FavoriteMoveToAdjacentList(Place place) : super(place);
}

/// Уведомить об изменении места.
class FavoriteNotifyPlace extends FavoriteEvent {
  const FavoriteNotifyPlace(this.notification) : super();

  final PlaceNotification notification;

  @override
  List<Object?> get props => [notification];

  @override
  String toString() => 'FavoriteNotifyPlace($notification)';
}
