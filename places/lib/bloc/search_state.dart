part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Состояние: загрузка результатов.
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Состояние: результат получен.
class SearchReady extends SearchState {
  const SearchReady(this.places);

  final List<Place> places;

  @override
  List<Object?> get props => [places];
}

/// Состояние: показ истории.
class SearchHistoryReady extends SearchState {
  const SearchHistoryReady(this.history);

  final List<SearchHistory> history;

  @override
  List<Object?> get props => [history];
}
