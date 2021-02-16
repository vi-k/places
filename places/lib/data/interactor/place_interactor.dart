import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_base.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/repository/base/filter.dart';
import 'package:places/data/repository/base/location_repository.dart';
import 'package:places/data/repository/base/place_repository.dart';
import 'package:places/data/repository/repository_exception.dart';

/// Интерактор для доступа к местам.
class PlaceInteractor {
  PlaceInteractor({
    required this.placeRepository,
    required this.locationRepository,
  });

  final PlaceRepository placeRepository;
  final LocationRepository locationRepository;

  final Map<int, PlaceUserInfo> _mockUserInfo = {
    31: PlaceUserInfo(
        favorite: Favorite.visited, planToVisit: DateTime(2016, 1, 1)),
    32: const PlaceUserInfo(favorite: Favorite.visited),
    33: PlaceUserInfo(
        favorite: Favorite.visited, planToVisit: DateTime(2005, 3, 3)),
    34: const PlaceUserInfo(favorite: Favorite.visited),
    35: const PlaceUserInfo(favorite: Favorite.wishlist),
    36: PlaceUserInfo(
        favorite: Favorite.wishlist, planToVisit: DateTime(2020, 6, 17)),
    37: const PlaceUserInfo(favorite: Favorite.wishlist),
  };

  /// Загружает список мест, соответствующих фильтру.
  Future<List<Place>> getPlaces(Filter filter) async {
    // Получаем список из репозитория
    final places = await placeRepository.filteredList(
        coord: locationRepository.location, filter: filter);

    // Сразу конвертируем PlaceBase в Place
    var index = -1;
    await Future.forEach<PlaceBase>(places, (place) async {
      try {
        index++; // Ассинхронная операция начинается с первой ассинхронной
        // функции, поэтому спокойно используем счётчик. Главное - помнить, где
        // его обновлять.
        places[index] = await _loadUserInfo(place);
      } on RepositoryException {
        // пока игнорируем ошибки
      }
    });

    return places.whereType<Place>().toList();
  }

  /// Загружает информацию о месте.
  Future<Place> getPlace(int id) async => _loadUserInfo(await _getPlace(id));

  /// Добавляет новое место.
  Future<int> addNewPlace(PlaceBase place) => placeRepository.create(place);

  /// Обновляет место.
  Future<void> updatePlace(PlaceBase place) => placeRepository.update(place);

  /// Удаляет место.
  Future<void> removePlace(int id) => placeRepository.delete(id);

  /// Загружает список "Хочу посетить".
  Future<List<Place>> getWishlist() =>
      _getPlacesByUserInfo(_mockUserInfo.entries
          .where((e) => e.value.favorite == Favorite.wishlist));

  /// Добавляет в список "Хочу посетить".
  Future<Place> addToWishlist(PlaceBase place) =>
      _addToFavorite(place, Favorite.wishlist);

  /// Удаляет из списка "Хочу посетить".
  Future<Place> removeFromWishlist(PlaceBase place) =>
      _removeFromFavorite(place, Favorite.wishlist);

  /// Переключает в список "Хочу посетить" и обратно.
  Future<Place> toggleWishlist(PlaceBase place) =>
      _toggleFavorite(place, Favorite.wishlist);

  /// Загружает посещённые места.
  Future<List<Place>> getVisited() => _getPlacesByUserInfo(
      _mockUserInfo.entries.where((e) => e.value.favorite == Favorite.visited));

  /// Добавляет в список посещённых мест.
  Future<Place> addToVisited(PlaceBase place) =>
      _addToFavorite(place, Favorite.visited);

  /// Удаляет из списка посещённых мест.
  Future<Place> removeFromVisited(PlaceBase place) =>
      _removeFromFavorite(place, Favorite.visited);

  /// Переключает в список посещённых мест и обратно.
  Future<Place> toggleVisited(PlaceBase place) =>
      _toggleFavorite(place, Favorite.visited);

  Future<Place> updateUserInfo(PlaceBase place, PlaceUserInfo userInfo) async {
    _mockUserInfo[place.id] = userInfo;
    return Place.from(place, userInfo: userInfo);
  }

  /// Загружает пользовательскую информацию о месте.
  Future<Place> _loadUserInfo(PlaceBase place) async => Place.from(place,
      userInfo: _mockUserInfo[place.id] ?? PlaceUserInfo.zero);

  /// Возвращает место по id.
  Future<PlaceBase> _getPlace(int id) => placeRepository.read(id);

  /// Возвращает список мест по списку пользовательской информации.
  Future<List<Place>> _getPlacesByUserInfo(
      Iterable<MapEntry<int, PlaceUserInfo>> iterable) async {
    final list = <Place>[];
    final coord = locationRepository.location;

    await Future.forEach<MapEntry<int, PlaceUserInfo>>(iterable, (e) async {
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
  Future<Place> _addToFavorite(PlaceBase place, Favorite favorite) async {
    final userInfo = _mockUserInfo[place.id] =
        _mockUserInfo[place.id]?.copyWith(favorite: favorite) ??
            PlaceUserInfo(favorite: favorite);
    return Place.from(place, userInfo: userInfo);
  }

  /// Удаляет из избранного.
  ///
  /// Или удаляет полностью, или, если есть заполненные данные, то
  /// удаляет соответствующую пометку. Если пользователь снова отметит место как
  /// избранное, то информация восстановится.
  Future<Place> _removeFromFavorite(PlaceBase place, Favorite favorite) async {
    var userInfo = _mockUserInfo[place.id] ?? PlaceUserInfo.zero;
    if (userInfo.favorite == favorite) {
      if (userInfo.isEmpty) {
        _mockUserInfo.remove(place.id);
        userInfo = PlaceUserInfo.zero;
      } else {
        userInfo =
            _mockUserInfo[place.id] = userInfo.copyWith(favorite: Favorite.no);
      }
    }
    return Place.from(place, userInfo: userInfo);
  }

  /// Переключает в избранное и обратно.
  Future<Place> _toggleFavorite(PlaceBase place, Favorite favorite) async {
    var userInfo = _mockUserInfo[place.id] ?? PlaceUserInfo.zero;
    if (userInfo.favorite != favorite) {
      userInfo =
          _mockUserInfo[place.id] = userInfo.copyWith(favorite: favorite);
    } else if (userInfo.isEmpty) {
      _mockUserInfo.remove(place.id);
      userInfo = PlaceUserInfo.zero;
    } else {
      userInfo =
          _mockUserInfo[place.id] = userInfo.copyWith(favorite: Favorite.no);
    }
    return Place.from(place, userInfo: userInfo);
  }
}
