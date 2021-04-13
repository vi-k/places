part of 'bloc_values.dart';

class BlocValue<T> extends Equatable {
  const BlocValue.undefined()
      : _value = null,
        isReady = false;

  const BlocValue(T value)
      : _value = value,
        isReady = true;

  final T? _value;
  final bool isReady;

  T get value => _value as T;
  bool get isNotReady => !isReady;

  @override
  List<Object?> get props => [_value, isReady];

  @override
  String toString() => !isReady
      ? '-'
      : value is String
          ? "'$value'"
          : '$value';

  String get state => isNotReady ? '-' : 'ok';
}
