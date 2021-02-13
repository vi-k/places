import 'package:places/utils/coord.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/string_ext.dart';

import 'place_type.dart';

/// Описание места.
class Place {
  const Place({
    this.id = 0,
    required this.name,
    required this.type,
    required this.coord,
    required this.photos,
    required this.description,
  });

  Place.from(Place place)
      : id = place.id,
        name = place.name,
        type = place.type,
        coord = place.coord,
        photos = place.photos,
        description = place.description;

  /// Идентификатор.
  final int id;

  /// Название.
  final String name;

  /// Тип.
  final PlaceType type;

  /// Координаты.
  final Coord coord;

  /// Фотографии.
  final List<String> photos;

  /// Описание.
  final String description;

  Distance distance(Coord from) => from.distance(coord);

  @override
  String toString({bool short = false, bool withType = true}) {
    if (withType) {
      return 'Place(${toString(short: short, withType: false)})';
    } else {
      final result = '#$id $name, ${type.id}, $coord';
      return short
          ? result
          : '$result, ${description.cut(20)}, '
              'photos: ${photos.length}';
    }
  }

  /// Копирует с внесением изменений.
  Place copyWith(
          {int? id,
          Coord? coord,
          String? name,
          List<String>? photos,
          PlaceType? type,
          String? description}) =>
      Place(
        id: id ?? this.id,
        coord: coord ?? this.coord,
        name: name ?? this.name,
        photos: photos ?? this.photos,
        type: type ?? this.type,
        description: description ?? this.description,
      );
}
