import 'package:places/utils/coord.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/enum.dart';

import 'place_base.dart';
import 'place_type.dart';
import 'place_user_info.dart';

enum Favorite { no, wishlist, visited }

extension FavoriteExt on Favorite {
  String get name => enumName(this);
}

/// Описание места.
class Place extends PlaceBase {
  Place({
    int id = 0,
    required String name,
    required PlaceType type,
    required Coord coord,
    required List<String> photos,
    required String description,
    Distance? distance,
    Coord? calcDistanceFrom,
    required this.userInfo,
  }) : super(
          id: id,
          name: name,
          type: type,
          coord: coord,
          distance: distance,
          calcDistanceFrom: calcDistanceFrom,
          photos: photos,
          description: description,
        );

  Place.from(
    PlaceBase place, {
    required this.userInfo,
  }) : super(
          id: place.id,
          name: place.name,
          type: place.type,
          coord: place.coord,
          distance: place.distance,
          photos: place.photos,
          description: place.description,
        );

  /// Пользовательская информация, сп.
  final PlaceUserInfo userInfo;

  @override
  List<Object?> get props =>
      [id, name, type, coord, photos, description, userInfo];

  bool get isNew => id == 0;

  @override
  String toString({bool short = false, bool withType = true}) => withType
      ? 'Place(${toString(short: short, withType: false)})'
      : '${super.toString(short: short, withType: false)}, '
          '${userInfo.toString(withType: false)}';

  /// Копирует с внесением изменений.
  @override
  // ignore: long-parameter-list
  Place copyWith({
    int? id,
    Coord? coord,
    String? name,
    List<String>? photos,
    PlaceType? type,
    String? description,
    Distance? distance,
    Coord? calcDistanceFrom,
    PlaceUserInfo? userInfo,
  }) =>
      Place(
        id: id ?? this.id,
        coord: coord ?? this.coord,
        name: name ?? this.name,
        photos: photos ?? this.photos,
        type: type ?? this.type,
        description: description ?? this.description,
        distance: distance ??
            calcDistanceFrom?.distance(coord ?? this.coord) ??
            this.distance,
        userInfo: userInfo ?? this.userInfo,
      );
}
