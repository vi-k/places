import 'dart:convert';

import 'package:places/data/model/place_base.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/utils/coord.dart';

/// Маппер для преобразования данных, полученных сервера в PlaceBase и обратно.
class ApiPlaceMapper {
  /// Парсит PlaceBase из строки.
  PlaceBase parse(String value) =>
      map(jsonDecode(value) as Map<String, dynamic>);

  /// Получает PlaceBase из Map.
  PlaceBase map(Map<String, dynamic> value, [Coord? calcDistanceFrom]) =>
      PlaceBase(
        id: value['id'] as int,
        coord: Coord(value['lat'] as double, value['lng'] as double),
        name: value['name'] as String,
        photos: (value['urls'] as List<dynamic>).whereType<String>().toList(),
        type: placeTypeByName(value['placeType'] as String),
        description: value['description'] as String,
        calcDistanceFrom: calcDistanceFrom,
      );

  /// Преобразует PlaceBase в строку.
  String stringify(PlaceBase value, {bool withId = true}) {
    final obj = <String, dynamic>{
      if (withId && value.id != 0) 'id': value.id,
      'lat': value.coord.lat,
      'lng': value.coord.lon,
      'name': value.name,
      'urls': value.photos,
      'placeType': value.type.name,
      'description': value.description,
    };

    return jsonEncode(obj);
  }
}
