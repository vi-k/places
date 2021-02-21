import 'package:places/data/model/settings.dart';

/// Интерактор для доступа к настройкам.
class SettingsInteractor {
  SettingsInteractor();

  Settings _mockSettings = const Settings(
    isDark: true,
    showTutorial: true,
  );

  /// Загружает список мест, соответствующих фильтру.
  Future<Settings> loadSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // throw Exception('тестовый сбой');
    return _mockSettings;
  }

  /// Изменяет и сохраняет настройки.
  Future<Settings> changeSettings({
    bool? isDark,
    bool? showTutorial,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _mockSettings = _mockSettings.copyWith(
      isDark: isDark,
      showTutorial: showTutorial,
    );
  }
}
