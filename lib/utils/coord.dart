import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import 'distance.dart';

part 'coord.g.dart';

/// Утилиты для работы с картографией.

/// Эллипсоид WGS84
const _ellipsoideA = 6378137.0; // большая полуось
const _ellipsoideF = 1.0 / 298.257223563; // сжатие (flattening)
const _ellipsoideB = _ellipsoideA * (1.0 - _ellipsoideF); // малая полуось
final _ellipsoideE =
    sqrt(_ellipsoideA * _ellipsoideA - _ellipsoideB * _ellipsoideB) /
        _ellipsoideA; // эксцентриситет эллипса (eccentricity)
final _ellipsoideE2 = _ellipsoideE * _ellipsoideE;

double calcDistance(double lat1, double lon1, double lat2, double lon2) {
  // Координаты первой точки
  final sinB1 = sin(lat1 * pi / 180.0);
  final cosB1 = cos(lat1 * pi / 180.0);
  final sinL1 = sin(lon1 * pi / 180.0);
  final cosL1 = cos(lon1 * pi / 180.0);

  // r1, r2 - радиусы кривизны первого вертикала на данной широте
  final r1 = _ellipsoideA / sqrt(1.0 - _ellipsoideE2 * sinB1 * sinB1);

  final x1 = r1 * cosB1 * cosL1;
  final y1 = r1 * cosB1 * sinL1;
  final z1 = (1.0 - _ellipsoideE2) * r1 * sinB1;

  // Координаты второй точки
  final sinB2 = sin(lat2 * pi / 180.0);
  final cosB2 = cos(lat2 * pi / 180.0);
  final sinL2 = sin(lon2 * pi / 180.0);
  final cosL2 = cos(lon2 * pi / 180.0);

  final r2 = _ellipsoideA / sqrt(1.0 - _ellipsoideE2 * sinB2 * sinB2);

  final x2 = r2 * cosB2 * cosL2;
  final y2 = r2 * cosB2 * sinL2;
  final z2 = (1.0 - _ellipsoideE2) * r2 * sinB2;

  // Расстояние между точками (размер хорды)
  final d = sqrt(
    (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1),
  );

  // Длина дуги по хорде. Главная проблема - выбрать радиус.
  // Проблема не решена! Но для местных условий (по краю),
  // оптимальным оказалось выбрать наименьший радиус
  // кривизны из двух рассчитанных
  final r = r1 < r2 ? r1 : r2;

  return 2.0 * r * asin(0.5 * d / r);
}

/// Координаты.
@JsonSerializable()
class Coord extends Equatable {
  const Coord(this.lat, this.lon);

  final double lat;
  final double lon;

  @override
  List<Object?> get props => [lat, lon];

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
  Map<String, dynamic> toJson() => _$CoordToJson(this);

  /// Рассчитывает расстояние между точками по методу хорды.
  ///
  /// Быстрее точных методов и точнее, чем расчёт по теореме Пифагора.
  ///
  /// Не подходит для точных расчётов на уровне планеты, материков и больших
  /// стран. Подходит для расчётов на уровне области/края.
  Distance distance(Coord to) =>
      Distance(calcDistance(lat, lon, to.lat, to.lon));

  @override
  String toString() => '(${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)})';
}
