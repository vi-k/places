import 'package:places/redux/action/search_action.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:places/redux/state/search_state.dart';

/// Редьюсеры (см. search_action.dart).
AppState searchStartReducer(AppState state, SearchStartAction action) =>
    state.copyWith(searchState: const SearchLoadingState());

AppState searchShowResultReducer(
        AppState state, SearchShowResultAction action) =>
    state.copyWith(searchState: SearchResultState(action.places));

AppState searchLoadHistoryReducer(
        AppState state, SearchLoadHistoryAction action) =>
    state.copyWith(searchState: const SearchLoadingState());

AppState searchShowHistoryReducer(
        AppState state, SearchShowHistoryAction action) =>
    state.copyWith(searchState: SearchHistoryState(action.history));

AppState searchClearHistoryReducer(
        AppState state, SearchClearHistoryAction action) =>
    state.copyWith(searchState: const SearchLoadingState());

AppState searchRemoveFromHistoryReducer(
        AppState state, SearchRemoveFromHistoryAction action) =>
    state.copyWith(searchState: const SearchLoadingState());
