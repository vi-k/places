import 'filter.dart';

/// Класс настроек.
class Settings {
  Settings({
    required this.onUpdate,
    required bool isDark,
  }) : _isDark = isDark;

  final void Function() onUpdate;

  Filter _filter = Filter();
  Filter get filter => _filter;
  set filter(Filter value) {
    _filter = value;
    onUpdate();
  }

  bool _isDark = false;
  bool get isDark => _isDark;
  set isDark(bool value) {
    _isDark = value;
    onUpdate();
  }
}
