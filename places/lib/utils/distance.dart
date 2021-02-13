import '../ui/res/strings.dart';
import 'num_ext.dart';

/// Единицы измерения для расстояния.
///
/// Используются для преобразования расстояния в строку.
enum DistanceUnits { optimal, meters, kilometers }

extension DistanceUnitsExt on DistanceUnits {
  String get name {
    switch (this) {
      case DistanceUnits.optimal:
        return '';
      case DistanceUnits.meters:
        return stringMeters;
      case DistanceUnits.kilometers:
        return stringKilometers;
    }
  }
}

/// Отдельный класс для расстояний.
///
/// Расстояние это обычный `double`. Цель создания отдельного класса - сделать
/// удобное преобразование в строку с переводом в различные единицы измерения.
class Distance implements Comparable<Distance> {
  const Distance(this.value);
  const Distance.km(double value) : value = value * 1000;

  final double value;

  static const Distance zero = Distance(0);
  static const Distance infinity = Distance(double.infinity);

  double get inKilometers => value / 1000;

  bool get isFinite => value.isFinite;
  bool get isInfinite => value.isInfinite;

  DistanceUnits get optimalUnits =>
      value.round() < 1000 ? DistanceUnits.meters : DistanceUnits.kilometers;

  @override
  String toString({
    DistanceUnits units = DistanceUnits.optimal,
    bool withUnits = true,
  }) {
    if (isInfinite) return '∞';

    final resultUnits = units == DistanceUnits.optimal ? optimalUnits : units;

    String result;
    if (resultUnits == DistanceUnits.meters) {
      result = value.toStringAsFixed(0);
    } else {
      result = (value / 1000)
          .toFixedWithoutTrailingZeros(value.round() < 10000 ? 1 : 0);
    }

    if (withUnits) result += ' ${resultUnits.name}';

    return result;
  }

  @override
  int compareTo(Distance other) => value.compareTo(other.value);

  bool operator >(Distance other) => value > other.value;
  bool operator >=(Distance other) => value >= other.value;
  bool operator <(Distance other) => value < other.value;
  bool operator <=(Distance other) => value <= other.value;
}
