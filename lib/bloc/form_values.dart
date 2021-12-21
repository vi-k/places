import 'form_value.dart';

/// Миксин для добавления списка значений формы [FormValue].
///
/// В результирующем классе необходимо будет переопределить свойство [values]:
/// ```
/// @override
/// List<FormValue> get values => [...];
/// ```
///
/// Если результирующий класс наследуется от [Equatable], то для свойства
/// [props] достаточно будет указать:
/// ```
/// @override
/// List<Object?> get props => [values];
/// ```
///
/// Если свойство [values] заполнено, то можно будет проверить сразу все
/// значения через свойства: [isValid], [isInvalid], [isModified].
mixin FormValues {
  List<FormValue> get values;

  bool get isValid => !values.any((value) => !value.isValid);
  bool get isNotValid => values.any((value) => !value.isValid);
  bool get isModified => values.any((element) => element.isModified);
}
