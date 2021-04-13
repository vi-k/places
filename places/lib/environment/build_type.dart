import 'package:places/utils/enum.dart';

/// Тип конфигурации.
enum BuildType { dev, prod }

extension BuildTypeExt on BuildType {
  String get name => enumName(this);
}
