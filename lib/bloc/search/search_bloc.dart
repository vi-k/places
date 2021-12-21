import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_request.dart';
import 'package:places/data/repositories/place/repository_exception.dart';

part 'search_event.dart';
part 'search_state.dart';

/// BLoC для поиска.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._placeInteractor) : super(const SearchInProgress()) {
    // Подписываемся на уведомления об изменении мест.
    _placeInteractorSubscription =
        _placeInteractor.stream.listen((notification) {
      add(SearchPlaceChanged(notification));
    });
  }

  final PlaceInteractor _placeInteractor;
  late final StreamSubscription<PlaceNotification> _placeInteractorSubscription;

  @override
  Future<void> close() async {
    await _placeInteractorSubscription.cancel();

    return super.close();
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchStarted) {
      if (event.text.isEmpty) {
        yield* _loadHistory();
      } else {
        yield* _search(event);
      }
    } else if (event is SearchHistoryCleared) {
      yield* _clearHistory(event);
    } else if (event is SearchRemovedFromHistory) {
      yield* _removeFromHistory(event);
    } else if (event is SearchPlaceChanged) {
      yield* _notifyPlace(event);
    }
  }

  // Ищет места в соответствии со строкой поиска.
  Stream<SearchState> _search(SearchStarted event) async* {
    yield const SearchInProgress();

    try {
      final results = await _placeInteractor.searchPlaces(event.text);
      yield SearchSuccess(results);
    } on RepositoryException catch (e) {
      yield SearchFailure(event.text, e);
    }
  }

  void _checkHistory() {
    if (state is! SearchHistory) {
      throw StateError('SearchBloc: The history not loaded. '
          'Dispatch a [SearchStarted] event.');
    }
  }

  // Загружает историю поиска.
  Stream<SearchState> _loadHistory() async* {
    yield const SearchInProgress();

    try {
      final history = await _placeInteractor.getSearchHistory();
      yield SearchHistory(history);
    } on RepositoryException catch (e) {
      yield SearchFailure('', e);
    }
  }

  // Очищает историю поиска.
  Stream<SearchState> _clearHistory(SearchHistoryCleared event) async* {
    _checkHistory();

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    yield const SearchSuccess([]);

    try {
      await _placeInteractor.clearSearchHistory();
    } on RepositoryException catch (e) {
      yield SearchFailure('', e);
    }
  }

  // Удаляет из истории поиска.
  Stream<SearchState> _removeFromHistory(
    SearchRemovedFromHistory event,
  ) async* {
    _checkHistory();

    final currentState = state as SearchHistory;

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newHistory = List<SearchRequest>.from(currentState.history)
      ..removeWhere((e) => e.text == event.text);
    yield SearchHistory(newHistory);

    try {
      await _placeInteractor.removeFromSearchHistory(event.text);
    } on RepositoryException catch (e) {
      yield SearchFailure('', e);
    }
  }

  // Обновляет место.
  Stream<SearchState> _notifyPlace(SearchPlaceChanged event) async* {
    final currentState = state;
    if (currentState is! SearchSuccess) return;

    final notification = event.notification;
    if (notification is PlaceNotificationWithPlace) {
      final place = notification.place;
      final places = currentState.places;
      final index = places.indexWhere((e) => e.id == place.id);
      if (index != -1) {
        final newPlaces = List<Place>.from(places);
        newPlaces[index] = place;
        yield SearchSuccess(newPlaces);
      }
    } else if (notification is PlaceRemoved) {
      final placeId = notification.placeId;
      final places = currentState.places;
      final index = places.indexWhere((e) => e.id == placeId);
      if (index != -1) {
        final newPlaces = List<Place>.from(places)..removeAt(index);
        yield SearchSuccess(newPlaces);
      }
    }
  }
}
