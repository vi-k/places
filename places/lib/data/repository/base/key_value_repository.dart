/// Интерфейс для хранения данных.
abstract class KeyValueRepository {
  Future<bool?> loadBool(String key);
  Future<int?> loadInt(String key);
  Future<double?> loadDouble(String key);
  Future<String?> loadString(String key);
  Future<List<String>?> loadStringList(String key);

  // ignore: avoid_positional_boolean_parameters
  Future<bool> saveBool(String key, bool value);
  Future<bool> saveInt(String key, int value);
  Future<bool> saveDouble(String key, double value);
  Future<bool> saveString(String key, String value);
  Future<bool> saveStringList(String key, List<String> value);

  Future<bool> remove(String key);
}
