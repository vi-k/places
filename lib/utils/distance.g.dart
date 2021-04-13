// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Distance _$DistanceFromJson(Map<String, dynamic> json) {
  return Distance(
    const DoubleConverter().fromJson(json['value'] as Object),
  );
}

Map<String, dynamic> _$DistanceToJson(Distance instance) => <String, dynamic>{
      'value': const DoubleConverter().toJson(instance.value),
    };
