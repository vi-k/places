import 'package:places/data/model/filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_base.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/model/search_request.dart';
import 'package:places/data/repository/db_repository/db_repository.dart';
import 'package:places/data/repository/location_repository/location_repository.dart';
import 'package:places/data/repository/place_repository/place_repository.dart';
import 'package:places/data/repository/place_repository/repository_exception.dart';

/// Интерактор для доступа к местам.
class PlaceInteractor {
  PlaceInteractor({
    required this.placeRepository,
    required this.dbRepository,
    required this.locationRepository,
  });

  final PlaceRepository placeRepository;
  final DbRepository dbRepository;
  final LocationRepository locationRepository;

  String _lastSearchRequest = '';

  /// Загружает список мест, соответствующих фильтру.
  Future<List<Place>> getPlaces(Filter filter) async {
    // Получаем список из репозитория
    final places = await placeRepository.loadFilteredList(
        coord: locationRepository.location, filter: filter);

    return _loadUserInfoForList(places);
  }

  /// Загружает список мест, содержащих в названии заданный текст.
  Future<List<Place>> searchPlaces(String requestText) async {
    // Получаем список из репозитория
    final request = requestText.toLowerCase();
    final places = await placeRepository.search(
        coord: locationRepository.location, text: request);

    if (places.isNotEmpty) {
      if (request.contains(_lastSearchRequest)) {
        await dbRepository.deleteSearchRequest(_lastSearchRequest);
      }
      _lastSearchRequest = request;
      await dbRepository.saveSearchRequest(SearchRequest(
        request,
        timestamp: DateTime.now(),
        count: places.length,
      ));
    }

    return _loadUserInfoForList(places);
  }

  /// Возвращает историю поиска.
  Future<List<SearchRequest>> getSearchHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return dbRepository.getSearchHistory();
  }

  /// Очищает историю поиска.
  Future<void> clearSearchHistory() => dbRepository.clearSearchHistory();

  /// Удаляет из истории поиска.
  Future<void> removeFromSearchHistory(String requestText) =>
      dbRepository.deleteSearchRequest(requestText);

  /// Загружает информацию о месте.
  Future<Place> getPlace(int id) async => _loadUserInfo(await _getPlace(id));

  /// Добавляет новое место.
  Future<Place> addNewPlace(PlaceBase place) async {
    final id = await placeRepository.create(place);
    return await getPlace(id);
  }

  /// Обновляет место.
  Future<void> updatePlace(PlaceBase place) => placeRepository.update(place);

  /// Удаляет место.
  Future<void> removePlace(int id) => placeRepository.delete(id);

  /// Загружает список "Хочу посетить".
  Future<List<Place>> getWishlist() async {
    final wishlist = await dbRepository.getFavorites(Favorite.wishlist);
    return _getPlacesByUserInfo(wishlist);
  }

  /// Добавляет в список "Хочу посетить".
  Future<Place> addToWishlist(Place place) =>
      _addToFavorite(place, Favorite.wishlist);

  /// Удаляет из списка "Хочу посетить".
  Future<Place> removeFromWishlist(Place place) =>
      _removeFromFavorite(place, Favorite.wishlist);

  /// Переключает в список "Хочу посетить" и обратно.
  Future<Place> toggleWishlist(Place place) =>
      _toggleFavorite(place, Favorite.wishlist);

  /// Загружает посещённые места.
  Future<List<Place>> getVisited() async {
    final visited = await dbRepository.getFavorites(Favorite.visited);
    return _getPlacesByUserInfo(visited);
  }

  /// Добавляет в список посещённых мест.
  Future<Place> addToVisited(Place place) =>
      _addToFavorite(place, Favorite.visited);

  /// Удаляет из списка посещённых мест.
  Future<Place> removeFromVisited(Place place) =>
      _removeFromFavorite(place, Favorite.visited);

  /// Переключает в список посещённых мест и обратно.
  Future<Place> toggleVisited(Place place) =>
      _toggleFavorite(place, Favorite.visited);

  Future<Place> updateUserInfo(PlaceBase place, PlaceUserInfo userInfo) async {
    await dbRepository.updatePlaceUserInfo(place.id, userInfo);
    return Place.from(place, userInfo: userInfo);
  }

  /// Загружает пользовательскую информацию о месте.
  Future<Place> _loadUserInfo(PlaceBase place) async => Place.from(
        place,
        userInfo: await dbRepository.loadPlaceUserInfo(place.id) ??
            PlaceUserInfo.zero,
      );

  /// Загружает пользовательскую информацию для списка.
  ///
  /// Список при этом модифицируется.
  Future<List<Place>> _loadUserInfoForList(List<PlaceBase> places) async {
    // Ассинхронно конвертируем PlaceBase в Place
    var index = -1;
    await Future.forEach<PlaceBase>(places, (place) async {
      try {
        index++; // Ассинхронная операция начинается с первой ассинхронной
        // функции, поэтому спокойно используем счётчик. Главное - обновлять
        // его до первой ассинхронной операции.

        // Подменяем элементы списка новыми данными.
        places[index] = await _loadUserInfo(place);
      } on RepositoryException {
        // Игнорируем ошибки
      }
    });

    // Конвертируем List<PlaseBase> в List<Place>.
    return places.whereType<Place>().toList();
  }

  /// Возвращает место по id.
  Future<PlaceBase> _getPlace(int id) => placeRepository.read(id);

  /// Возвращает список мест по списку пользовательской информации.
  Future<List<Place>> _getPlacesByUserInfo(Map<int, PlaceUserInfo> map) async {
    final list = <Place>[];
    final coord = locationRepository.location;

    await Future.forEach<MapEntry<int, PlaceUserInfo>>(map.entries, (e) async {
      try {
        final place = (await _getPlace(e.key)).copyWith(calDistanceFrom: coord);
        list.add(Place.from(place, userInfo: e.value));
      } on RepositoryException {
        // пока игнорируем ошибки
      }
    });

    list.sort((a, b) => a.distance.compareTo(b.distance));

    return list;
  }

  /// Добавляет в избранное.
  Future<Place> _addToFavorite(Place place, Favorite favorite) async {
    final newUserInfo = place.userInfo.copyWith(favorite: favorite);
    await dbRepository.updatePlaceUserInfo(place.id, newUserInfo);
    return Place.from(place, userInfo: newUserInfo);
  }

  /// Удаляет из избранного.
  ///
  /// Или удаляет полностью, или, если есть заполненные данные, то
  /// удаляет соответствующую пометку. Если пользователь снова отметит место как
  /// избранное, то информация восстановится.
  Future<Place> _removeFromFavorite(Place place, Favorite favorite) async {
    final newUserInfo = place.userInfo.copyWith(favorite: Favorite.no);
    await dbRepository.updatePlaceUserInfo(place.id, newUserInfo);
    return Place.from(place, userInfo: newUserInfo);
  }

  /// Переключает в избранное и обратно.
  Future<Place> _toggleFavorite(Place place, Favorite favorite) async {
    PlaceUserInfo newUserInfo;
    if (place.userInfo.favorite != favorite) {
      newUserInfo = place.userInfo.copyWith(favorite: favorite);
    } else {
      newUserInfo = place.userInfo.copyWith(favorite: Favorite.no);
    }
    await dbRepository.updatePlaceUserInfo(place.id, newUserInfo);
    return Place.from(place, userInfo: newUserInfo);
  }
}
