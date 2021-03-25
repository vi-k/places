import 'package:equatable/equatable.dart';

import 'filter.dart';

/// Настройки.
class Settings extends Equatable {
  const Settings({
    required this.isDark,
    required this.showTutorial,
    required this.filter,
  });

  final bool isDark;
  final bool showTutorial;
  final Filter filter;

  @override
  List<Object?> get props => [isDark, showTutorial, filter];

  @override
  String toString() => 'Settings(isDark: $isDark, '
      'showTutorial: $showTutorial, '
      'filter: $filter)';

  Settings copyWith({
    bool? isDark,
    bool? showTutorial,
    Filter? filter,
  }) =>
      Settings(
        isDark: isDark ?? this.isDark,
        showTutorial: showTutorial ?? this.showTutorial,
        filter: filter ?? this.filter,
      );
}
