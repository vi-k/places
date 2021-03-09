import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history.dart';

abstract class SearchState {
  const SearchState();

  @override
  String toString() => runtimeType.toString();
}

/// Начальное состояние.
class SearchInitialState extends SearchState {
  const SearchInitialState();
}

/// Состояние: загрузка результатов.
class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

/// Состояние: результат получен.
class SearchResultState extends SearchState {
  const SearchResultState(this.places);

  final List<Place> places;

  @override
  String toString() => 'SearchResultState(places: ${places.length})';
}

/// Состояние: показ истории.
class SearchHistoryState extends SearchState {
  const SearchHistoryState(this.history);

  final List<SearchHistory> history;

  @override
  String toString() => 'SearchHistoryState(history: ${history.length})';
}
