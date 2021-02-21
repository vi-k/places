/// Настройки.
class Settings {
  const Settings({
    required this.isDark,
    required this.showTutorial,
  });

  final bool isDark;
  final bool showTutorial;

  @override
  String toString() => 'Settings(isDark: $isDark)';

  Settings copyWith({
    bool? isDark,
    bool? showTutorial,
  }) =>
      Settings(
        isDark: isDark ?? this.isDark,
        showTutorial: showTutorial ?? this.showTutorial,
      );
}
