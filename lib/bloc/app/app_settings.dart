import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

/// Настройки.
@JsonSerializable()
class AppSettings extends Equatable {
  const AppSettings({
    required this.isDark,
    required this.showTutorial,
    required this.animationDuration,
  });

  const AppSettings.init()
      : isDark = false,
        showTutorial = true,
        animationDuration = 300;

  final bool isDark;
  final bool showTutorial;

  @JsonKey(defaultValue: 300)
  final int animationDuration;

  @override
  List<Object?> get props => [isDark, showTutorial, animationDuration];

  @override
  String toString() => 'Settings(isDark: $isDark, '
      'showTutorial: $showTutorial, '
      'animationDuration: $animationDuration)';

  AppSettings copyWith({
    bool? isDark,
    bool? showTutorial,
    int? animationDuration,
  }) =>
      AppSettings(
        isDark: isDark ?? this.isDark,
        showTutorial: showTutorial ?? this.showTutorial,
        animationDuration: animationDuration ?? this.animationDuration,
      );

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  factory AppSettings.parseJson(String json) =>
      AppSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  String jsonStringify() => jsonEncode(toJson());
}
