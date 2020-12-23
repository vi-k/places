import 'filter.dart';

/// Класс настроек.
class Settings {
  Settings(this.onUpdate);

  final void Function() onUpdate;

  Filter _filter = Filter();
  Filter get filter => _filter;
  set filter(Filter value) {
    _filter = value;
    onUpdate();
  }

  bool _isDark  = false;
  bool get isDark => _isDark;
  set isDark(bool value) {
    _isDark = value;
    onUpdate();
  }
  void toggleIsDark() => isDark = !isDark;
}