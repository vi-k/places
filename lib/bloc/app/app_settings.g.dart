// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return AppSettings(
    isDark: json['isDark'] as bool,
    showTutorial: json['showTutorial'] as bool,
    animationDuration: json['animationDuration'] as int? ?? 300,
  );
}

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'isDark': instance.isDark,
      'showTutorial': instance.showTutorial,
      'animationDuration': instance.animationDuration,
    };
