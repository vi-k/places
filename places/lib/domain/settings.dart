import 'filter.dart';

class Settings {
  Settings(this.onUpdate);
  // factory Settings() => _instance ?? Settings._();
  // static Settings? _instance;

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