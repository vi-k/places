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
  });

  const AppSettings.init()
      : isDark = false,
        showTutorial = true;

  final bool isDark;
  final bool showTutorial;

  @override
  List<Object?> get props => [isDark, showTutorial];

  @override
  String toString() => 'Settings(isDark: $isDark, showTutorial: $showTutorial)';

  AppSettings copyWith({
    bool? isDark,
    bool? showTutorial,
  }) =>
      AppSettings(
        isDark: isDark ?? this.isDark,
        showTutorial: showTutorial ?? this.showTutorial,
      );

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  factory AppSettings.parseJson(String json) =>
      AppSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  String jsonStringify() => jsonEncode(toJson());
}
