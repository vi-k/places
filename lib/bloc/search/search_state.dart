part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Загрузка результатов.
class SearchInProgress extends SearchState {
  const SearchInProgress();
}

/// Результаты поиска.
class SearchSuccess extends SearchState {
  const SearchSuccess(this.places);

  final List<Place> places;

  @override
  List<Object?> get props => [places];
}

/// Ошибка загрузки результатов поиска.
class SearchFailure extends SearchState {
  const SearchFailure(this.text, this.error) : super();

  final String text;
  final Exception error;

  @override
  List<Object?> get props => [text, error];
}

/// История поиска.
class SearchHistory extends SearchState {
  const SearchHistory(this.history);

  final List<SearchRequest> history;

  @override
  List<Object?> get props => [history];
}
