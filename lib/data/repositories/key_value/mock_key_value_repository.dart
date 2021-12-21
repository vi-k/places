import 'key_value_repository.dart';

// Иммитация хранения данных.
class MockKeyValueRepository extends KeyValueRepository {
  final _map = <String, Object>{};

  @override
  Future<bool?> loadBool(String section, String key) async =>
      _map[path(section, key)] as bool?;

  @override
  Future<int?> loadInt(String section, String key) async =>
      _map[path(section, key)] as int?;

  @override
  Future<double?> loadDouble(String section, String key) async =>
      _map[path(section, key)] as double?;

  @override
  Future<String?> loadString(String section, String key) async =>
      _map[path(section, key)] as String?;

  @override
  Future<List<String>?> loadStringList(String section, String key) async =>
      _map[path(section, key)] as List<String>?;

  @override
  Future<bool> saveBool(String section, String key, bool value) async {
    _map[path(section, key)] = value;

    return true;
  }

  @override
  Future<bool> saveInt(String section, String key, int value) async {
    _map[path(section, key)] = value;

    return true;
  }

  @override
  Future<bool> saveDouble(String section, String key, double value) async {
    _map[path(section, key)] = value;

    return true;
  }

  @override
  Future<bool> saveString(String section, String key, String value) async {
    _map[path(section, key)] = value;

    return true;
  }

  @override
  Future<bool> saveStringList(
    String section,
    String key,
    List<String> value,
  ) async {
    _map[path(section, key)] = value;

    return true;
  }

  @override
  Future<bool> remove(String section, String key) async =>
      _map.remove(path(section, key)) != null;
}
