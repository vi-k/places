// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filter _$FilterFromJson(Map<String, dynamic> json) {
  return Filter(
    radius: Distance.fromJson(json['radius'] as Map<String, dynamic>),
    placeTypes: (json['placeTypes'] as List<dynamic>?)
        ?.map((e) => _$enumDecode(_$PlaceTypeEnumMap, e))
        .toSet(),
  );
}

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'radius': instance.radius,
      'placeTypes':
          instance.placeTypes?.map((e) => _$PlaceTypeEnumMap[e]).toList(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PlaceTypeEnumMap = {
  PlaceType.cafe: 'cafe',
  PlaceType.hotel: 'hotel',
  PlaceType.museum: 'museum',
  PlaceType.park: 'park',
  PlaceType.restaurant: 'restaurant',
  PlaceType.other: 'other',
};
