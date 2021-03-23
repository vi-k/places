import 'package:places/data/model/search_request.dart';

/// Интерфейс для работы с БД.
mixin DbRepository {
  Future<List<SearchRequest>> getSearchHistory();
  Future<void> saveSearchRequest(SearchRequest query);
  Future<void> deleteSearchRequest(String queryText);
  Future<void> clearSearchHistory();
}
