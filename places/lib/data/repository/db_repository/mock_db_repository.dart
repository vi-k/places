import 'package:places/data/model/search_request.dart';

import 'db_repository.dart';

/// Имитация базы данных.
class MockDbRepository with DbRepository {
  MockDbRepository();

  final Map<String, SearchRequest> _searchHistory = {};

  @override
  Future<List<SearchRequest>> getSearchHistory() async =>
      _searchHistory.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  @override
  Future<void> saveSearchRequest(SearchRequest query) async {
    _searchHistory[query.text] = query;
  }

  @override
  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
  }

  @override
  Future<void> deleteSearchRequest(String requestText) async {
    _searchHistory.remove(requestText);
  }
}
