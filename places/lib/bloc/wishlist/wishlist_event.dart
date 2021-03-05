part of 'wishlist_bloc.dart';

@immutable
// ignore: one_member_abstracts
abstract class WishlistEvent {}

/// Событие: загружаем список "Хочу посетить".
class WishlistLoad extends WishlistEvent {}

/// Событие: удаляем карточку из списка "Хочу посетить".
class WishlistDelete extends WishlistEvent {
  WishlistDelete(this.place);

  final Place place;
}
