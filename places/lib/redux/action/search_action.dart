import 'package:places/data/model/place.dart';
import 'package:places/data/model/search_history.dart';

abstract class SearchAction {
  const SearchAction();

  @override
  String toString() => runtimeType.toString();
}

/// Начать поиск.
class SearchStartAction extends SearchAction {
  const SearchStartAction(this.text);

  final String text;

  @override
  String toString() => 'SearchStartAction(text: $text)';
}

/// Вывести результат поиска.
class SearchShowResultAction extends SearchAction {
  const SearchShowResultAction(this.places);

  final List<Place> places;

  @override
  String toString() => 'SearchResultAction(places: ${places.length})';
}

/// Загрузить историю поиска.
class SearchLoadHistoryAction extends SearchAction {
  const SearchLoadHistoryAction();
}

/// Показать историю поиска.
class SearchShowHistoryAction extends SearchAction {
  const SearchShowHistoryAction(this.history);

  final List<SearchHistory> history;

  @override
  String toString() =>
      'SearchShowHistoryAction(history: ${history.length})';
}

/// Очистить историю поиска.
class SearchClearHistoryAction extends SearchAction {
  const SearchClearHistoryAction();
}

/// Удалить запись из истории поиска.
class SearchRemoveFromHistoryAction extends SearchAction {
  const SearchRemoveFromHistoryAction(this.text);

  final String text;
}
