import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_extended.dart';
import 'package:places/data/repository/base/filter.dart';
import 'package:places/data/repository/base/location_repository.dart';
import 'package:places/data/repository/base/place_repository.dart';
import 'package:places/data/repository/repository_exception.dart';

import 'model/place_extension.dart';

/// Интерактор для доступа к местам.
class PlaceInteractor {
  PlaceInteractor({
    required this.placeRepository,
    required this.locationRepository,
  });

  final PlaceRepository placeRepository;
  final LocationRepository locationRepository;

  final Map<int, PlaceExtension> _extensions = {
    31: PlaceExtension(Favorite.visited, DateTime(2016, 1, 1)),
    32: const PlaceExtension(Favorite.visited),
    33: PlaceExtension(Favorite.visited, DateTime(2005, 3, 3)),
    34: const PlaceExtension(Favorite.visited),
    35: const PlaceExtension(Favorite.wishlist),
    36: PlaceExtension(Favorite.wishlist, DateTime(2020, 6, 17)),
    37: const PlaceExtension(Favorite.wishlist),
  };

  /// Загружает список мест, соответствующих фильтру.
  Future<List<Place>> getPlaces(Filter filter) => placeRepository.filteredList(
      coord: locationRepository.location, filter: filter);

  /// Загружает доп. информацию о месте.
  Future<PlaceExtended> getPlaceExtended(Place place) async {
    final ext = _extensions[place.id] ?? PlaceExtension.zero;
    return ext.toPlaceExtended(place);
  }

  /// Загружает информацию о месте.
  Future<Place> getPlace(int id) => placeRepository.read(id);

  /// Добавляет новое место.
  Future<int> addNewPlace(Place place) => placeRepository.create(place);

  Future<List<PlaceExtended>> _getPlacesExtended(
      Iterable<MapEntry<int, PlaceExtension>> iterable) async {
    final list = <PlaceExtended>[];

    await Future.forEach<MapEntry<int, PlaceExtension>>(iterable, (e) async {
      try {
        final place = await getPlace(e.key);
        list.add(e.value.toPlaceExtended(place));
      } on RepositoryException {
        // пока игнорируем ошибки
      }
    });

    final coord = locationRepository.location;
    list.sort((a, b) => a.distance(coord).compareTo(b.distance(coord)));

    return list;
  }

  /// Загружает список "Хочу посетить".
  Future<List<PlaceExtended>> getWishlist() => _getPlacesExtended(
      _extensions.entries.where((e) => e.value.favorite == Favorite.wishlist));

  /// Добавляет в избранное.
  Future<PlaceExtended> _addToFavorite(Place place, Favorite favorite) async {
    final ext = _extensions[place.id] =
        _extensions[place.id]?.copyWith(favorite: favorite) ??
            PlaceExtension(favorite);
    return ext.toPlaceExtended(place);
  }

  /// Удаляет из избранного.
  ///
  /// Но если есть заполненные данные, то только удаляет соответствующую
  /// пометку.
  Future<PlaceExtended> _removeFromFavorite(
      Place place, Favorite favorite) async {
    var ext = _extensions[place.id] ?? PlaceExtension.zero;
    if (ext.favorite == favorite) {
      if (ext.isEmpty) {
        _extensions.remove(place.id);
        ext = PlaceExtension.zero;
      } else {
        ext = _extensions[place.id] = ext.copyWith(favorite: Favorite.no);
      }
    }
    return ext.toPlaceExtended(place);
  }

  /// Переключает в избранное и обратно.
  Future<PlaceExtended> _toggleFavorite(Place place, Favorite favorite) async {
    var ext = _extensions[place.id] ?? PlaceExtension.zero;
    if (ext.favorite != favorite) {
      ext = _extensions[place.id] = ext.copyWith(favorite: favorite);
    } else if (ext.isEmpty) {
      _extensions.remove(place.id);
      ext = PlaceExtension.zero;
    } else {
      ext = _extensions[place.id] = ext.copyWith(favorite: Favorite.no);
    }
    return ext.toPlaceExtended(place);
  }

  /// Добавляет в список "Хочу посетить".
  Future<PlaceExtended> addToWishlist(Place place) =>
      _addToFavorite(place, Favorite.wishlist);

  /// Удаляет из списка "Хочу посетить".
  Future<PlaceExtended> removeFromWishlist(Place place) =>
      _removeFromFavorite(place, Favorite.wishlist);

  /// Переключает в список "Хочу посетить" и обратно.
  Future<PlaceExtended> toggleWishlist(Place place) =>
      _toggleFavorite(place, Favorite.wishlist);

  /// Загружает посещённые места.
  Future<List<PlaceExtended>> getVisited() => _getPlacesExtended(
      _extensions.entries.where((e) => e.value.favorite == Favorite.visited));

  /// Добавляет в список посещённых мест.
  Future<PlaceExtended> addToVisited(Place place) =>
      _addToFavorite(place, Favorite.visited);

  /// Удаляет из списка посещённых мест.
  Future<PlaceExtended> removeFromVisited(Place place) =>
      _removeFromFavorite(place, Favorite.visited);

  /// Переключает в список посещённых мест и обратно.
  Future<PlaceExtended> toggleVisited(Place place) =>
      _toggleFavorite(place, Favorite.visited);

  Future<PlaceExtended> updateExtension(Place place, PlaceExtension ext) async {
    _extensions[place.id] = ext;
    return ext.toPlaceExtended(place);
  }
}
