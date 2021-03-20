import 'package:equatable/equatable.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/let_and_also.dart';
import 'package:places/utils/string_ext.dart';

import 'place_type.dart';

/// Описание места (информация, не зависящая от пользователя).
class PlaceBase extends Equatable {
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

  /// Фотографии.
  final List<String> photos;

  /// Описание.
  final String description;

  /// Расстояние до заданного объекта (если задан).
  ///
  /// Поле, не относящееся к данным - исключительно для хранения рассчитанных
  /// данных. Можно было бы рассчитывать каждый раз заново. Что лучше -
  /// рассчитывать или сохранять - вопрос спорный.
  final Distance distance;

  @override
  List<Object?> get props => [id, name, type, coord, photos, description];

  @override
  String toString({bool short = false, bool withType = true}) {
    if (withType) {
      return 'PlaceBase(${toString(short: short, withType: false)})';
    } else {
      final result = '#$id "$name", ${type.name}, $distance';
      return short
          ? result
          : '$result, $coord, "${description.cut(20)}", '
              'photos: $photos';
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
