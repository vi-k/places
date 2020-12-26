///

final RegExp _trailingZerosRe = RegExp(r'\.?0+(?=e|$)');

extension DoubleExt on double {
  String toFixedWithoutTrailingZeros(int fractionDigits) {
    final result = toStringAsFixed(fractionDigits);
    return result.contains('.')
        ? result.replaceFirst(_trailingZerosRe, '')
        : result;
  }
}
