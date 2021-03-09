import 'package:places/redux/action/search_action.dart';
import 'package:places/redux/reducer/search_reducer.dart';
import 'package:places/redux/state/app_state.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:redux/redux.dart';

/// Основной редьюсер.
final reducer = combineReducers<AppState>([
  TypedReducer<AppState, SearchStartAction>(searchStartReducer),
  TypedReducer<AppState, SearchShowResultAction>(searchShowResultReducer),
  TypedReducer<AppState, SearchLoadHistoryAction>(searchLoadHistoryReducer),
  TypedReducer<AppState, SearchShowHistoryAction>(searchShowHistoryReducer),
  TypedReducer<AppState, SearchClearHistoryAction>(searchClearHistoryReducer),
  TypedReducer<AppState, SearchRemoveFromHistoryAction>(
      searchRemoveFromHistoryReducer),
]);
