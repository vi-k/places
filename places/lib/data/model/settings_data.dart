/// Настройки.
class SettingsData {
  const SettingsData({
    required this.isDark,
    required this.showTutorial,
  });

  final bool isDark;
  final bool showTutorial;

  @override
  String toString() => 'SettingsData(isDark: $isDark)';

  SettingsData copyWith({
    bool? isDark,
    bool? showTutorial,
  }) =>
      SettingsData(
        isDark: isDark ?? this.isDark,
        showTutorial: showTutorial ?? this.showTutorial,
      );
}
