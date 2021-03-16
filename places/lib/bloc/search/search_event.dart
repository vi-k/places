part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

/// Начать поиск.
class Search extends SearchEvent {
  const Search(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

/// Загрузить историю поиска.
class SearchLoadHistory extends SearchEvent {
  const SearchLoadHistory();
}

/// Очистить историю поиска.
class SearchClearHistory extends SearchEvent {
  const SearchClearHistory();
}

/// Удалить запись из истории поиска.
class SearchRemoveFromHistory extends SearchEvent {
  const SearchRemoveFromHistory(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}
