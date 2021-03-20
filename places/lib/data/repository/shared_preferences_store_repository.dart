import 'package:shared_preferences/shared_preferences.dart';

import 'base/store_repository.dart';

// Хранение данных через SharedPreferences.
class SharedPreferencesStoreRepository extends StoreRepository {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getSharedPreferences() async =>
      _prefs ?? await SharedPreferences.getInstance();

  @override
  Future<bool?> loadBool(String key) async =>
      (await _getSharedPreferences()).getBool(key);

  @override
  Future<int?> loadInt(String key) async =>
      (await _getSharedPreferences()).getInt(key);

  @override
  Future<double?> loadDouble(String key) async =>
      (await _getSharedPreferences()).getDouble(key);

  @override
  Future<String?> loadString(String key) async =>
      (await _getSharedPreferences()).getString(key);

  @override
  Future<List<String>?> loadStringList(String key) async =>
      (await _getSharedPreferences()).getStringList(key);

  @override
  Future<bool> saveBool(String key, bool value) async =>
      await (await _getSharedPreferences()).setBool(key, value);

  @override
  Future<bool> saveInt(String key, int value) async =>
      await (await _getSharedPreferences()).setInt(key, value);

  @override
  Future<bool> saveDouble(String key, double value) async =>
      await (await _getSharedPreferences()).setDouble(key, value);

  @override
  Future<bool> saveString(String key, String value) async =>
      await (await _getSharedPreferences()).setString(key, value);

  @override
  Future<bool> saveStringList(String key, List<String> value) async =>
      await (await _getSharedPreferences()).setStringList(key, value);

  @override
  Future<bool> remove(String key) async {
    final prefs = await _getSharedPreferences();
    return await prefs.remove(key);
  }
}
