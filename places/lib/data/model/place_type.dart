import 'package:places/utils/enum.dart';

enum PlaceType { cafe, hotel, museum, park, restaurant, other }

extension PlaceTypeEnumExt on PlaceType {
  String get name => enumName(this);
}

const Map<String, PlaceType> _map = {
  'cafe': PlaceType.cafe,
  'hotel': PlaceType.hotel,
  'museum': PlaceType.museum,
  'park': PlaceType.park,
  'restaurant': PlaceType.restaurant,
  'other': PlaceType.other,
  'temple': PlaceType.other,
};

PlaceType? placeTypeByName(String name) => _map[name] ?? PlaceType.other;
