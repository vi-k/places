import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/model/search_request.dart';

/// Интерфейс для работы с БД.
abstract class DbRepository {
  Future<List<SearchRequest>> getSearchHistory();
  Future<void> saveSearchRequest(SearchRequest request);
  Future<void> deleteSearchRequest(String requestText);
  Future<void> clearSearchHistory();

  Future<Map<int, PlaceUserInfo>> getFavorites(Favorite type);
  Future<PlaceUserInfo?> loadPlaceUserInfo(int placeId);
  Future<void> updatePlaceUserInfo(int placeId, PlaceUserInfo userInfo);
}
