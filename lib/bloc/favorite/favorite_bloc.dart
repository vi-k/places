import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/bloc/bloc_values.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repositories/place/repository_exception.dart';

part 'wishlist_bloc.dart';
part 'visited_bloc.dart';
part 'favorite_event.dart';
part 'favorite_state.dart';

/// Базовый класс BLoC'а для избранного.
///
/// Реализации: [WishlistBloc] и [VisitedBloc]
abstract class _FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  _FavoriteBloc._(this._placeInteractor) : super(const FavoriteState.init()) {
    // Подписываемся на уведомления об изменении мест.
    _placeInteractorSubscription =
        _placeInteractor.stream.listen((notification) {
      add(FavoritePlaceChanged(notification));
    });
  }

  final PlaceInteractor _placeInteractor;
  late final StreamSubscription<PlaceNotification> _placeInteractorSubscription;

  Future<List<Place>> _getList();
  Future<Place> _removeFromList(Place place);
  Future<Place> _addToAdjacentList(Place place);
  bool _isOwn(Place place);

  @override
  Future<void> close() async {
    await _placeInteractorSubscription.cancel();

    return super.close();
  }

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteStarted) {
      yield* _load();
    } else if (event is FavoritePlaceRemoved) {
      yield* _removePlace(event);
    } else if (event is FavoritePlaceMoved) {
      yield* _moveToAdjacentList(event);
    } else if (event is FavoritePlaceChanged) {
      yield* _updatePlace(event);
    }
  }

  // Проверяет, загружены ли места.
  void _checkPlaces() {
    if (state.places.isNotReady) {
      throw StateError('$runtimeType: The places not loaded. '
          'Dispatch a [FavoriteStarted] event.');
    }
  }

  // Загружает избранное.
  Stream<FavoriteState> _load() async* {
    yield FavoriteLoadInProgress(state);
    try {
      final places = await _getList();
      yield state.copyWith(places: BlocValue(places));
    } on RepositoryException catch (e) {
      yield FavoriteLoadFailure(state, e);
    }
  }

  // Удаляет место из списка.
  Stream<FavoriteState> _removePlace(FavoritePlaceRemoved event) async* {
    _checkPlaces();

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newPlaces = List<Place>.from(state.places.value)..remove(event.place);
    yield state.copyWith(places: BlocValue(newPlaces));

    // Потом удаляем из хранилища.
    try {
      await _removeFromList(event.place);
    } on RepositoryException catch (e) {
      yield FavoriteLoadFailure(state, e);
    }
  }

  // Переносит в соседний список.
  Stream<FavoriteState> _moveToAdjacentList(FavoritePlaceMoved event) async* {
    _checkPlaces();

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newPlaces = List<Place>.from(state.places.value)..remove(event.place);
    yield state.copyWith(places: BlocValue(newPlaces));

    // Потом переносим в хранилище.
    try {
      await _removeFromList(event.place);
      await _addToAdjacentList(event.place);
    } on RepositoryException catch (e) {
      yield FavoriteLoadFailure(state, e);
    }
  }

  // Обновляет место.
  Stream<FavoriteState> _updatePlace(FavoritePlaceChanged event) async* {
    if (state.places.isNotReady) return;

    final notification = event.notification;
    if (notification is PlaceNotificationWithPlace) {
      final place = notification.place;
      final places = state.places.value;
      final index = places.indexWhere((e) => e.id == place.id);

      if (index != -1) {
        final newPlaces = List<Place>.from(places);
        if (_isOwn(place)) {
          newPlaces[index] = place;
        } else {
          newPlaces.removeAt(index);
        }
        yield state.copyWith(places: BlocValue(newPlaces));
      } else if (_isOwn(place)) {
        final newPlaces = List<Place>.from(places)..insert(0, place);
        yield state.copyWith(places: BlocValue(newPlaces));
      }
    } else if (notification is PlaceRemoved) {
      final placeId = notification.placeId;
      final places = state.places.value;
      final index = places.indexWhere((e) => e.id == placeId);

      if (index != -1) {
        final newPlaces = List<Place>.from(places)..removeAt(index);
        yield state.copyWith(places: BlocValue(newPlaces));
      }
    }
  }
}
