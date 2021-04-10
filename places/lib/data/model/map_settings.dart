import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:places/utils/coord.dart';

part 'map_settings.g.dart';

/// Настройки карты.
@JsonSerializable()
class MapSettings extends Equatable {
  const MapSettings({
    required this.location,
    required this.zoom,
    required this.bearing,
    required this.tilt,
  });

  final Coord location;
  final double zoom;
  final double bearing;
  final double tilt;

  @override
  List<Object> get props => [location, zoom, bearing, tilt];

  @override
  String toString() =>
      'MapSettings(location: $location, zoom: $zoom, bearing: $bearing, $tilt)';

  factory MapSettings.fromJson(Map<String, dynamic> json) =>
      _$MapSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$MapSettingsToJson(this);

  factory MapSettings.parseJson(String json) =>
      MapSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  String jsonStringify() => jsonEncode(toJson());
}
