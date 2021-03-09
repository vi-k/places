import 'package:places/redux/state/search_state.dart';

/// Состояние приложения для Redux.
class AppState {
  AppState({
    this.searchState = const SearchInitialState(),
  });

  final SearchState searchState;

  AppState copyWith({
    SearchState? searchState,
  }) =>
      AppState(
        searchState: searchState ?? this.searchState,
      );
}
