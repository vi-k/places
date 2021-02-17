import 'package:places/domain/settings_data.dart';

/// Интерактор для доступа к настройкам.
class SettingsInteractor {
  SettingsInteractor();

  SettingsData _mockSettingsData = const SettingsData(
    isDark: true,
    showTutorial: false,
  );

  /// Загружает список мест, соответствующих фильтру.
  // ignore: avoid_positional_boolean_parameters
  Future<SettingsData> loadSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    // throw Exception('тестовый сбой');
    return _mockSettingsData;
  }

  Future<SettingsData> changeSettings({
    bool? isDark,
    bool? showTutorial,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _mockSettingsData = _mockSettingsData.copyWith(
      isDark: isDark,
      showTutorial: showTutorial,
    );
  }
}
