part of 'wishlist_bloc.dart';

@immutable
// ignore: one_member_abstracts
abstract class WishlistEvent {
  Stream<WishlistState> apply(WishlistState currentState, WishlistBloc bloc);
}

/// Событие: загружаем список "Хочу посетить".
class WishlistLoad extends WishlistEvent {
  @override
  Stream<WishlistState> apply(
      WishlistState currentState, WishlistBloc bloc) async* {
    yield WishlistLoading();
    final places = await bloc.getList();
    yield WishlistLoaded(places);
  }
}

/// Событие: удаляем карточку из списка "Хочу посетить".
///
/// Чтобы пользователь не ждал, делаем это вручную без перезагрузки списка.
class WishlistDelete extends WishlistEvent {
  WishlistDelete(this.place);

  final Place place;

  @override
  Stream<WishlistState> apply(
      WishlistState currentState, WishlistBloc bloc) async* {
    if (currentState is! WishlistLoaded) {
      yield WishlistLoading();
      await bloc.removeFromList(place);
      final places = await bloc.getList();
      yield WishlistLoaded(places);
    } else {
      final newPlaces = List<Place>.from(currentState.places)..remove(place);
      yield WishlistLoaded(newPlaces);
      // В нормальном случае здесь надо добавить обработку ошибок и при ошибке
      // перезагружать список.
      await bloc.removeFromList(place);
    }
  }
}
