import 'package:shared_preferences/shared_preferences.dart';

import 'base/key_value_repository.dart';

// Хранение данных через SharedPreferences.
class SharedPreferencesRepository extends KeyValueRepository {
  @override
  Future<bool?> loadBool(String key) async =>
      (await SharedPreferences.getInstance()).getBool(key);

  @override
  Future<int?> loadInt(String key) async =>
      (await SharedPreferences.getInstance()).getInt(key);

  @override
  Future<double?> loadDouble(String key) async =>
      (await SharedPreferences.getInstance()).getDouble(key);

  @override
  Future<String?> loadString(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);

  @override
  Future<List<String>?> loadStringList(String key) async =>
      (await SharedPreferences.getInstance()).getStringList(key);

  @override
  Future<bool> saveBool(String key, bool value) async =>
      (await SharedPreferences.getInstance()).setBool(key, value);

  @override
  Future<bool> saveInt(String key, int value) async =>
      (await SharedPreferences.getInstance()).setInt(key, value);

  @override
  Future<bool> saveDouble(String key, double value) async =>
      (await SharedPreferences.getInstance()).setDouble(key, value);

  @override
  Future<bool> saveString(String key, String value) async =>
      (await SharedPreferences.getInstance()).setString(key, value);

  @override
  Future<bool> saveStringList(String key, List<String> value) async =>
      (await SharedPreferences.getInstance()).setStringList(key, value);

  @override
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
