import 'dart:math';

import '../ui/res/strings.dart';
import 'num_ext.dart';

/* Эллипсоид WGS84 */
const _ellipsoideA = 6378137.0; /* большая полуось */
const _ellipsoideF = 1.0 / 298.257223563; /* сжатие (flattening) */
const _ellipsoideB = _ellipsoideA * (1.0 - _ellipsoideF); /* малая полуось */
final _ellipsoideE =
    sqrt(_ellipsoideA * _ellipsoideA - _ellipsoideB * _ellipsoideB) /
        _ellipsoideA; /* эксцентриситет эллипса (eccentricity) */
final _ellipsoideE2 = _ellipsoideE * _ellipsoideE;
// final _ellipsoideE4 = _ellipsoideE2 * _ellipsoideE2;
// final _ellipsoideE6 = _ellipsoideE4 * _ellipsoideE2;
// final _ellipsoideE8 = _ellipsoideE4 * _ellipsoideE4;
// const _ellipsoideK = 1.0 - _ellipsoideF;

class Coord {
  const Coord(this.lat, this.lon);

  final double lat;
  final double lon;

  /// Быстрый рассчёт расстояния между точками по методу хорды.
  /// Метод можно использовать на небольших расстояниях.
  Distance distance(Coord to) {
    // Координаты первой точки
    final sinB1 = sin(lat * pi / 180.0);
    final cosB1 = cos(lat * pi / 180.0);
    final sinL1 = sin(lon * pi / 180.0);
    final cosL1 = cos(lon * pi / 180.0);

    // r1, r2 - радиусы кривизны первого вертикала на данной широте
    final r1 = _ellipsoideA / sqrt(1.0 - _ellipsoideE2 * sinB1 * sinB1);

    final x1 = r1 * cosB1 * cosL1;
    final y1 = r1 * cosB1 * sinL1;
    final z1 = (1.0 - _ellipsoideE2) * r1 * sinB1;

    // Координаты второй точки
    final sinB2 = sin(to.lat * pi / 180.0);
    final cosB2 = cos(to.lat * pi / 180.0);
    final sinL2 = sin(to.lon * pi / 180.0);
    final cosL2 = cos(to.lon * pi / 180.0);

    final r2 = _ellipsoideA / sqrt(1.0 - _ellipsoideE2 * sinB2 * sinB2);

    final x2 = r2 * cosB2 * cosL2;
    final y2 = r2 * cosB2 * sinL2;
    final z2 = (1.0 - _ellipsoideE2) * r2 * sinB2;

    // Расстояние между точками (размер хорды)
    final d = sqrt(
        (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1));

    // Длина дуги по хорде. Главная проблема - выбрать радиус.
    // Проблема не решена! Но для местных условий (по краю),
    // оптимальным оказалось выбрать наименьший радиус
    // кривизны из двух рассчитанных
    final r = r1 < r2 ? r1 : r2;

    return Distance(2.0 * r * asin(0.5 * d / r));
  }
}

enum DistanceUnits { optimal, meters, kilometers }

extension DistanceUnitsExt on DistanceUnits {
  String get name {
    switch (this) {
      case DistanceUnits.optimal:
        return '';
      case DistanceUnits.meters:
        return meters;
      case DistanceUnits.kilometers:
        return kilometers;
    }
  }
}

class Distance implements Comparable<Distance> {
  const Distance(this.value);

  final double value;

  double get inKilometers => value / 1000;
  DistanceUnits get optimalUnits =>
      value.round() < 1000 ? DistanceUnits.meters : DistanceUnits.kilometers;

  @override
  String toString({
    DistanceUnits units = DistanceUnits.optimal,
    bool withUnits = true,
  }) {
    final resultUnits = units == DistanceUnits.optimal ? optimalUnits : units;

    String result;
    if (resultUnits == DistanceUnits.meters) {
      result = value.toStringAsFixed(0);
    } else {
      result = (value / 1000)
          .toStringAsFixedWithoutTrailingZeros(value.round() < 10000 ? 1 : 0);
    }

    if (withUnits) result += ' ${resultUnits.name}';

    return result;
  }

  @override
  int compareTo(Distance other) => value.compareTo(other.value);
}
