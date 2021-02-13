import 'enum.dart';

enum Sort { asc, desc }

extension SortExt on Sort {
  String get name => nameFromEnum(this);
}
