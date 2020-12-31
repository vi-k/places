import 'package:flutter/foundation.dart';

/// Класс настроек.
///
class SettingsData extends ChangeNotifier {
  SettingsData({
    required bool isDark,
  }) : _isDark = isDark;

  bool _isDark = false;
  bool get isDark => _isDark;
  set isDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  @override
  String toString() => 'SettingsData(isDark: $_isDark)';
}
