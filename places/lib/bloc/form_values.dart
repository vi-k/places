import 'form_value.dart';

mixin FormValues {
  List<FormValue> get values;

  bool get isValid => !values.any((value) => !value.isValid);
  bool get isNotValid => values.any((value) => !value.isValid);
  bool get isModified => values.any((element) => element.isModified);
}
