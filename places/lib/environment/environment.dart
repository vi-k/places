import 'package:logger/logger.dart';

import 'build_config.dart';
import 'build_type.dart';


/// Рабочее оокружение.
class Environment {
  static late final Environment _instance;
  static Environment get instance => _instance;

  Environment._(this.buildType, this.buildConfig);

  final BuildType buildType;
  final BuildConfig buildConfig;

  static void init({
    required BuildType buildType,
    required BuildConfig buildConfig,
    Level? loggerLevel,
    LogFilter? logFilter,
  }) {
    _instance = Environment._(buildType, buildConfig);
  }
}
