part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType()';
}

/// Начать поиск.
class Search extends SearchEvent {
  const Search(this.text);

  final String text;

  @override
  List<Object?> get props => [text];

  @override
  String toString() => 'Search($text)';
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
  List<Object?> get props => [text];

  @override
  String toString() => 'SearchRemoveFromHistory($text)';
}

/// Уведомить об изменении места.
class SearchNotifyPlace extends SearchEvent {
  const SearchNotifyPlace(this.notification) : super();

  final PlaceNotification notification;

  @override
  List<Object?> get props => [notification];

  @override
  String toString() => 'SearchNotifyPlace($notification)';
}
