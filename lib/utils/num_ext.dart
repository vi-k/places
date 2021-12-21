final RegExp _trailingZerosRe = RegExp(r'\.?0+(?=e|$)');

/// Расширения для преобразования числа с плавающей запятой в фиксированный
/// формат, но с удалением конечных незначащих нулей.
extension DoubleExt on double {
  String toFixedWithoutTrailingZeros(int fractionDigits) {
    final result = toStringAsFixed(fractionDigits);

    return result.contains('.')
        ? result.replaceFirst(_trailingZerosRe, '')
        : result;
  }
}
