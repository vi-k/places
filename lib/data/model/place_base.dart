import 'package:equatable/equatable.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/let_and_also.dart';
import 'package:places/utils/string_ext.dart';

import 'place_type.dart';

/// Описание места (информация, не зависящая от пользователя).
class PlaceBase extends Equatable implements Comparable<PlaceBase> {
  PlaceBase({
    this.id = 0,
    required this.name,
    required this.type,
    required this.coord,
    required List<String> photos,
    required this.description,
    Distance? distance,
    Coord? calcDistanceFrom,
  })  : photos = List.unmodifiable(photos),
        assert(distance == null || calcDistanceFrom == null),
        distance = distance ?? calcDistanceFrom?.distance(coord);

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
  final Distance? distance;

  @override
  List<Object?> get props => [id, name, type, coord, photos, description];

  @override
  int compareTo(PlaceBase other) {
    final d1 = distance;
    final d2 = other.distance;

    if (d1 == null) {
      return d2 == null ? name.compareTo(other.name) : -1;
    }

    if (d2 == null) return 1;

    return d1.compareTo(d2);
  }

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
  // ignore: long-parameter-list
  PlaceBase copyWith({
    int? id,
    Coord? coord,
    String? name,
    List<String>? photos,
    PlaceType? type,
    String? description,
    Distance? distance,
    Coord? calcDistanceFrom,
  }) {
    assert(distance == null || calcDistanceFrom == null);

    return PlaceBase(
      id: id ?? this.id,
      coord: coord ?? this.coord,
      name: name ?? this.name,
      photos: photos?.let((it) => List.unmodifiable(it)) ?? this.photos,
      type: type ?? this.type,
      description: description ?? this.description,
      distance: distance ??
          calcDistanceFrom?.distance(coord ?? this.coord) ??
          this.distance,
    );
  }
}
