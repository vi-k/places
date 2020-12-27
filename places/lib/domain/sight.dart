import 'dart:collection';

import '../ui/res/svg.dart';
import '../utils/maps.dart';

/// Интересное место.
class Sight {
  Sight({
    required this.id,
    required this.name,
    required this.coord,
    required List<String> photos,
    required this.details,
    required this.category,
    this.visited = false,
    this.visitTime,
    this.visitedTime,
  }) : photos = UnmodifiableListView(photos);

  final int id;
  final String name;
  final Coord coord;
  final UnmodifiableListView<String> photos;
  final String details;
  final SightCategory category;
  final bool visited;
  final DateTime? visitTime;
  final DateTime? visitedTime;

  @override
  String toString() => 'Sight(id: $id, $name, ${category.text}, $coord ...)';

  Sight copyWith({
    int? id,
    String? name,
    Coord? coord,
    List<String>? photos,
    String? details,
    SightCategory? category,
    bool? visited,
    DateTime? visitTime,
    DateTime? visitedTime,
  }) =>
      Sight(
        id: id ?? this.id,
        name: name ?? this.name,
        coord: coord ?? this.coord,
        photos: photos ?? this.photos,
        details: details ?? this.details,
        category: category ?? this.category,
        visited: visited ?? this.visited,
        visitTime: visitTime ?? this.visitTime,
        visitedTime: visitedTime ?? this.visitedTime,
      );
}

/// Категория места.
enum SightCategory {
  cafe,
  hotel,
  museum,
  restaurant,
  park,
  particular,
}

/// Временное решение вопроса с иконкой и наименованием категории.
///
/// Если предполагать, что категории можно добавлять, то это всё должно
/// храниться в БД.
class _SightCategoryInfo {
  _SightCategoryInfo(this.asset, this.text);

  final String asset;
  final String text;
}

final _categoryInfo = {
  SightCategory.cafe: _SightCategoryInfo(Svg32.cafe, 'Кафе'),
  SightCategory.hotel: _SightCategoryInfo(Svg32.hotel, 'Гостиница'),
  SightCategory.museum: _SightCategoryInfo(Svg32.museum, 'Музей'),
  SightCategory.restaurant: _SightCategoryInfo(Svg32.restaurant, 'Ресторан'),
  SightCategory.park: _SightCategoryInfo(Svg32.park, 'Парк'),
  SightCategory.particular:
      _SightCategoryInfo(Svg32.particularPlace, 'Особое место'),
};

/// Добавляет свойства к категориям.
extension SightCategoryExt on SightCategory {
  String get asset => _categoryInfo[this]!.asset;
  String get text => _categoryInfo[this]!.text;
}
