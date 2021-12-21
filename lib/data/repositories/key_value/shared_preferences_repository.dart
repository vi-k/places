import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_repository.dart';

// Хранение данных через SharedPreferences.
class SharedPreferencesRepository extends KeyValueRepository {
  @override
  Future<bool?> loadBool(String section, String key) async =>
      (await SharedPreferences.getInstance()).getBool(path(section, key));

  @override
  Future<int?> loadInt(String section, String key) async =>
      (await SharedPreferences.getInstance()).getInt(path(section, key));

  @override
  Future<double?> loadDouble(String section, String key) async =>
      (await SharedPreferences.getInstance()).getDouble(path(section, key));

  @override
  Future<String?> loadString(String section, String key) async =>
      (await SharedPreferences.getInstance()).getString(path(section, key));

  @override
  Future<List<String>?> loadStringList(String section, String key) async =>
      (await SharedPreferences.getInstance()).getStringList(path(section, key));

  @override
  Future<bool> saveBool(String section, String key, bool value) async =>
      (await SharedPreferences.getInstance())
          .setBool(path(section, key), value);

  @override
  Future<bool> saveInt(String section, String key, int value) async =>
      (await SharedPreferences.getInstance()).setInt(path(section, key), value);

  @override
  Future<bool> saveDouble(String section, String key, double value) async =>
      (await SharedPreferences.getInstance())
          .setDouble(path(section, key), value);

  @override
  Future<bool> saveString(String section, String key, String value) async =>
      (await SharedPreferences.getInstance())
          .setString(path(section, key), value);

  @override
  Future<bool> saveStringList(
    String section,
    String key,
    List<String> value,
  ) async =>
      (await SharedPreferences.getInstance())
          .setStringList(path(section, key), value);

  @override
  Future<bool> remove(String section, String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove(path(section, key));
  }
}
