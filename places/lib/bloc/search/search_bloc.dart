import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._placeInteractor) : super(const SearchLoading());

  final PlaceInteractor _placeInteractor;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    print(event);
    if (event is Search) {
      yield* _search(event);
    } else if (event is SearchLoadHistory) {
      yield* _loadHistory(event);
    } else if (event is SearchClearHistory) {
      yield* _clearHistory(event);
    } else if (event is SearchRemoveFromHistory) {
      yield* _removeFromHistory(event);
    }
  }

  Stream<SearchState> _search(Search event) async* {
    yield const SearchLoading();
    final history = await _placeInteractor.searchPlaces(event.text);
    yield SearchReady(history);
  }

  Stream<SearchState> _loadHistory(SearchLoadHistory event) async* {
    yield const SearchLoading();
    final history = await _placeInteractor.getSearchHistory();
    yield SearchHistoryReady(history);
  }

  Stream<SearchState> _clearHistory(SearchClearHistory event) async* {
    assert(state is SearchHistoryReady);

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    yield const SearchReady([]);
    // TODO: Добавить обработку ошибок.
    await _placeInteractor.clearSearchHistory();
  }

  Stream<SearchState> _removeFromHistory(SearchRemoveFromHistory event) async* {
    assert(state is SearchHistoryReady);
    final currentState = state as SearchHistoryReady;

    // Чтобы пользователь не ждал, удаляем вручную без перезагрузки списка.
    final newHistory = List<SearchHistory>.from(currentState.history)
      ..removeWhere((e) => e.text == event.text);
    yield SearchHistoryReady(newHistory);
    // TODO: Добавить обработку ошибок.
    await _placeInteractor.removeFromSearchHistory(event.text);
  }
}
