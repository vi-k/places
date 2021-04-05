import 'key_value_repository.dart';

// Иммитация хранения данных.
class MockKeyValueRepository extends KeyValueRepository {
  final _map = <String, Object>{};

  @override
  Future<bool?> loadBool(String key) async => _map[key] as bool?;

  @override
  Future<int?> loadInt(String key) async => _map[key] as int?;

  @override
  Future<double?> loadDouble(String key) async => _map[key] as double?;

  @override
  Future<String?> loadString(String key) async => _map[key] as String?;

  @override
  Future<List<String>?> loadStringList(String key) async =>
      _map[key] as List<String>?;

  @override
  Future<bool> saveBool(String key, bool value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> saveInt(String key, int value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> saveDouble(String key, double value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> saveString(String key, String value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> saveStringList(String key, List<String> value) async {
    _map[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async => _map.remove(key) != null;
}
