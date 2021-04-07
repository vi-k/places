// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapSettings _$MapSettingsFromJson(Map<String, dynamic> json) {
  return MapSettings(
    location: Coord.fromJson(json['location'] as Map<String, dynamic>),
    zoom: (json['zoom'] as num).toDouble(),
    bearing: (json['bearing'] as num).toDouble(),
    tilt: (json['tilt'] as num).toDouble(),
  );
}

Map<String, dynamic> _$MapSettingsToJson(MapSettings instance) =>
    <String, dynamic>{
      'location': instance.location,
      'zoom': instance.zoom,
      'bearing': instance.bearing,
      'tilt': instance.tilt,
    };
