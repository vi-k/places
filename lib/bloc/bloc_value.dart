part of 'bloc_values.dart';

/// Класс для работы со значениями в блоке.
///
/// Значение может быть готово или не готово к использованию (свойство
/// `isReady`). Для первого используется стандартный конструктор [BlocValue],
/// для второго конструктор [BlocValue.undefined]. Если значение не готово,
/// обращение к свойству [value] для non nullable типов выдаст ошибку, для
/// nullable типов вернёт `null`.
///
/// Это класс, когда использование ассинхронных `Future` и `Stream` излишне,
/// и нужен синхронный код.
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
