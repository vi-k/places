import 'package:equatable/equatable.dart';

part 'bloc_value.dart';

mixin BlocValues {
  List<BlocValue> get values;

  bool get isReady => !values.any((value) => value.isNotReady);
  bool get isNotReady => values.any((value) => value.isNotReady);
}
