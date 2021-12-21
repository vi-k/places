import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/model/search_request.dart';

import 'db_repository.dart';

/// Имитация базы данных.
class MockDbRepository extends DbRepository {
  MockDbRepository();

  final Map<String, SearchRequest> _searchHistory = {};
  final Map<int, PlaceUserInfo> _placesUserInfo = {};

  @override
  Future<List<SearchRequest>> getSearchHistory() async =>
      _searchHistory.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  @override
  Future<void> saveSearchRequest(SearchRequest request) async {
    _searchHistory[request.text] = request;
  }

  @override
  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
  }

  @override
  Future<void> deleteSearchRequest(String requestText) async {
    _searchHistory.remove(requestText);
  }

  @override
  Future<Map<int, PlaceUserInfo>> getFavorites(Favorite type) async =>
      Map<int, PlaceUserInfo>.fromEntries(
        _placesUserInfo.entries.where((e) => e.value.favorite == type),
      );

  @override
  Future<PlaceUserInfo?> loadPlaceUserInfo(int placeId) async =>
      _placesUserInfo[placeId];

  @override
  Future<void> updatePlaceUserInfo(int placeId, PlaceUserInfo userInfo) async {
    if (userInfo.favorite == Favorite.no && userInfo.isEmpty) {
      _placesUserInfo.removeWhere((key, value) => key == placeId);
    } else {
      _placesUserInfo[placeId] = userInfo;
    }
  }

  @override
  Future<void> removePlaceUserInfo(int placeId) async =>
      _placesUserInfo.removeWhere((key, value) => key == placeId);
}
