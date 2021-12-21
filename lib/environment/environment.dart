import 'build_config.dart';
import 'build_type.dart';


/// Рабочее оокружение.
class Environment {
  static late final Environment _instance;

  Environment._(this._buildType, this._buildConfig);

  final BuildType _buildType;
  final BuildConfig _buildConfig;

  static BuildType get buildType => _instance._buildType;
  static BuildConfig get buildConfig => _instance._buildConfig;

  static void init({
    required BuildType buildType,
    required BuildConfig buildConfig,
  }) {
    _instance = Environment._(buildType, buildConfig);
  }
}
