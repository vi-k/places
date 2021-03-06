import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/redux/action/search_action.dart';
import 'package:places/redux/state/app_state.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:redux/redux.dart';

/// Работа с поиском.
class SearchMiddleware implements MiddlewareClass<AppState> {
  SearchMiddleware(this.placeInteractor);

  final PlaceInteractor placeInteractor;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    asyncHandle(store, action);
    next(action);
  }

  Future<void> asyncHandle(Store<AppState> store, dynamic action) async {
    if (action is SearchStartAction) {
      final places = await placeInteractor.searchPlaces(action.text);
      store.dispatch(SearchShowResultAction(places));
    } else if (action is SearchLoadHistoryAction) {
      final history = await placeInteractor.getSearchHistory();
      store.dispatch(SearchShowHistoryAction(history));
    } else if (action is SearchClearHistoryAction) {
      await placeInteractor.clearSearchHistory();
      store.dispatch(const SearchShowHistoryAction([]));
    } else if (action is SearchRemoveFromHistoryAction) {
      await placeInteractor.removeFromSearchHistory(action.text);
      store.dispatch(const SearchLoadHistoryAction());
    }
  }
}
