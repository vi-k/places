import '../ui/res/strings.dart';
import '../utils/maps.dart';

/// Интересное место.
class Sight {
  final String name;
  final Coord coord;
  final String url;
  final String details;
  final SightCategory category;
  final DateTime? visitTime;
  final DateTime? visited;

  Sight({
    required this.name,
    required this.coord,
    required this.url,
    required this.details,
    required this.category,
    this.visitTime,
    this.visited,
  });

  @override
  String toString() => 'Sight($name, ${category.text}, $coord ...)';
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
