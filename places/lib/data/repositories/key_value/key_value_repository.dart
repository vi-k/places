/// Интерфейс для хранения данных.
abstract class KeyValueRepository {
  Future<bool?> loadBool(String section, String key);
  Future<int?> loadInt(String section, String key);
  Future<double?> loadDouble(String section, String key);
  Future<String?> loadString(String section, String key);
  Future<List<String>?> loadStringList(String section, String key);

  // ignore: avoid_positional_boolean_parameters
  Future<bool> saveBool(String section, String key, bool value);
  Future<bool> saveInt(String section, String key, int value);
  Future<bool> saveDouble(String section, String key, double value);
  Future<bool> saveString(String section, String key, String value);
  Future<bool> saveStringList(String section, String key, List<String> value);

  Future<bool> remove(String section, String key);

  String path(String section, String key) => '$section.$key';
}
