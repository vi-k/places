import 'package:flutter/foundation.dart';

enum PlaceTypeEnum { cafe, hotel, museum, park, restaurant, other }

@immutable
class PlaceType {
  const PlaceType._(this.value);

  final PlaceTypeEnum value;

  static const PlaceType cafe = PlaceType._(PlaceTypeEnum.cafe);
  static const PlaceType hotel = PlaceType._(PlaceTypeEnum.hotel);
  static const PlaceType museum = PlaceType._(PlaceTypeEnum.museum);
  static const PlaceType park = PlaceType._(PlaceTypeEnum.park);
  static const PlaceType restaurant = PlaceType._(PlaceTypeEnum.restaurant);
  static const PlaceType other = PlaceType._(PlaceTypeEnum.other);

  static PlaceType? byId(String value) => _map[value];

  String get id => _map.entries.singleWhere((e) => e.value.value == value).key;

  static Set<PlaceType> get all => _map.values.toSet();

  @override
  String toString() => 'PlaceType($id)';

  static const _map = {
    'cafe': PlaceType.cafe,
    'hotel': PlaceType.hotel,
    'museum': PlaceType.museum,
    'park': PlaceType.park,
    'restaurant': PlaceType.restaurant,
    'other': PlaceType.other,
  };

  @override
  bool operator ==(covariant PlaceType other) => value == other.value;

  @override
  int get hashCode => value.hashCode;
}
