import 'package:equatable/equatable.dart';

enum FormValueState { undefined, underway, valid, invalid }

class FormValue<T> extends Equatable {
  const FormValue._(
    this.value,
    this.isModified,
    this.state,
    this.error,
  );

  const FormValue(
    this.value, {
    this.state = FormValueState.underway,
    this.error,
  }) : isModified = false;

  const FormValue.undefined(T value, {String? error})
      : this(value, state: FormValueState.undefined, error: error);
  const FormValue.valid(T value) : this(value, state: FormValueState.valid);
  const FormValue.invalid(T value, {required String error})
      : this(value, state: FormValueState.invalid, error: error);

  final T value;
  final bool isModified;
  final FormValueState state;
  final String? error;

  @override
  List<Object?> get props => [value, isModified, state, error];

  bool get isUndefined => state == FormValueState.undefined;
  bool get isUnderway => state == FormValueState.underway;
  bool get isValid => state == FormValueState.valid;
  bool get isInvalid => state == FormValueState.invalid;

  FormValue<T> toUndefined({String? error}) => FormValue._(
      value, isModified, FormValueState.undefined, error ?? this.error);
  FormValue<T> toUnderway() =>
      FormValue._(value, isModified, FormValueState.underway, null);
  FormValue<T> toValid() =>
      FormValue._(value, isModified, FormValueState.valid, null);
  FormValue<T> toInvalid({required String error}) =>
      FormValue._(value, isModified, FormValueState.invalid, error);

  FormValue<T> toSaved() => FormValue._(value, false, state, error);

  FormValue<T> setValue(T value, {bool save = false}) => FormValue._(
      value, !save && (isModified || value != this.value), state, error);

  @override
  String toString({bool value = true, bool info = true}) => [
        if (value) this.value is String ? "'${this.value}'" : '${this.value}',
        if (info)
          [
            state.toString().replaceFirst(RegExp(r'.*\.'), ''),
            if (isModified) 'modified',
            if (error != null) "'$error'",
          ].join(' '),
      ].join(' ');
}
