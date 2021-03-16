import 'package:equatable/equatable.dart';

/// Настройки.
class Settings extends Equatable {
  const Settings({
    required this.isDark,
    required this.showTutorial,
  });

  final bool isDark;
  final bool showTutorial;

  @override
  List<Object?> get props => [isDark, showTutorial];

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
