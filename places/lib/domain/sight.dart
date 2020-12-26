import 'package:equatable/equatable.dart';

import '../ui/res/strings.dart';
import '../utils/maps.dart';

/// Интересное место.
class Sight extends Equatable {
  Sight({
    required this.name,
    required this.coord,
    // required this.photos,
    required List<String> photos,
    required this.details,
    required this.category,
    this.visitTime,
    this.visited,
  }) : photos = List<String>.unmodifiable(photos);

  final String name;
  final Coord coord;
  final List<String> photos;
  final String details;
  final SightCategory category;
  final DateTime? visitTime;
  final DateTime? visited;

  @override
  List<Object?> get props =>
      [name, coord, photos, details, category, visitTime, visited];

  @override
  String toString() => 'Sight($name, ${category.text}, $coord ...)';

  Sight copyWith({
    String? name,
    Coord? coord,
    List<String>? photos,
    String? details,
    SightCategory? category,
    DateTime? visitTime,
    DateTime? visited,
  }) =>
      Sight(
        name: name ?? this.name,
        coord: coord ?? this.coord,
        photos: photos ?? this.photos,
        details: details ?? this.details,
        category: category ?? this.category,
        visitTime: visitTime ?? this.visitTime,
        visited: visited ?? this.visited,
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
  SightCategory.cafe: _SightCategoryInfo(assetCafe, 'Кафе'),
  SightCategory.hotel: _SightCategoryInfo(assetHotel, 'Гостиница'),
  SightCategory.museum: _SightCategoryInfo(assetMuseum, 'Музей'),
  SightCategory.restaurant: _SightCategoryInfo(assetRestaurant, 'Ресторан'),
  SightCategory.park: _SightCategoryInfo(assetMuseum, 'Парк'),
  SightCategory.particular: _SightCategoryInfo(assetParticular, 'Особое место'),
};

/// Добавляет свойства к категориям.
extension SightCategoryExt on SightCategory {
  String get asset => _categoryInfo[this]!.asset;
  String get text => _categoryInfo[this]!.text;
}
