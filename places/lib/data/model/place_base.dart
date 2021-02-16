import 'package:places/utils/coord.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/let_and_also.dart';
import 'package:places/utils/string_ext.dart';

import 'place_type.dart';

/// Описание места.
class PlaceBase {
  PlaceBase({
    this.id = 0,
    required this.name,
    required this.type,
    required this.coord,
    required List<String> photos,
    required this.description,
    Distance? distance,
    Coord? calDistanceFrom,
  })  : photos = List.unmodifiable(photos),
        assert(distance == null || calDistanceFrom == null),
        distance =
            distance ?? calDistanceFrom?.distance(coord) ?? Distance.zero;

  /// Идентификатор.
  final int id;

  /// Название.
  final String name;

  /// Тип.
  final PlaceType type;

  /// Координаты.
  final Coord coord;

  /// Расстояние до заданного объекта (если задан).
  final Distance distance;

  /// Фотографии.
  final List<String> photos;

  /// Описание.
  final String description;

  @override
  String toString({bool short = false, bool withType = true}) {
    if (withType) {
      return 'PlaceBase(${toString(short: short, withType: false)})';
    } else {
      final result = '#$id $name, ${type.name}, $coord';
      return short
          ? result
          : '$result, ${description.cut(20)}, '
              'photos: ${photos.length}';
    }
  }

  /// Копирует с внесением изменений.
  PlaceBase copyWith({
    int? id,
    Coord? coord,
    String? name,
    List<String>? photos,
    PlaceType? type,
    String? description,
    Distance? distance,
    Coord? calDistanceFrom,
  }) {
    assert(distance == null || calDistanceFrom == null);
    return PlaceBase(
      id: id ?? this.id,
      coord: coord ?? this.coord,
      name: name ?? this.name,
      photos: photos?.let((it) => List.unmodifiable(it)) ?? this.photos,
      type: type ?? this.type,
      description: description ?? this.description,
      distance: distance ??
          calDistanceFrom?.distance(coord ?? this.coord) ??
          this.distance,
    );
  }
}
