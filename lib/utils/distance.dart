import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:places/ui/res/strings.dart';

import 'json.dart';
import 'num_ext.dart';

part 'distance.g.dart';

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
@JsonSerializable()
class Distance extends Equatable implements Comparable<Distance> {
  const Distance(this.value);
  const Distance.km(double value) : value = value * 1000;

  @DoubleConverter()
  final double value;

  static const Distance zero = Distance(0);
  static const Distance infinity = Distance(double.infinity);

  double get inKilometers => value / 1000;

  bool get isFinite => value.isFinite;
  bool get isInfinite => value.isInfinite;

  DistanceUnits get optimalUnits =>
      value.round() < 1000 ? DistanceUnits.meters : DistanceUnits.kilometers;

  @override
  List<Object?> get props => [value];

  @override
  String toString({
    DistanceUnits units = DistanceUnits.optimal,
    bool withUnits = true,
  }) {
    if (isInfinite) return '∞';

    final resultUnits = units == DistanceUnits.optimal ? optimalUnits : units;

    var result = resultUnits == DistanceUnits.meters
        ? value.toStringAsFixed(0)
        : (value / 1000)
            .toFixedWithoutTrailingZeros(value.round() < 10000 ? 1 : 0);

    if (withUnits) result += ' ${resultUnits.name}';

    return result;
  }

  @override
  int compareTo(Distance other) => value.compareTo(other.value);

  bool operator >(Distance other) => value > other.value;
  bool operator >=(Distance other) => value >= other.value;
  bool operator <(Distance other) => value < other.value;
  bool operator <=(Distance other) => value <= other.value;

  factory Distance.fromJson(Map<String, dynamic> json) =>
      _$DistanceFromJson(json);
  Map<String, dynamic> toJson() => _$DistanceToJson(this);

  factory Distance.parseJson(String json) =>
      Distance.fromJson(jsonDecode(json) as Map<String, dynamic>);
  String jsonStringify() => jsonEncode(toJson());
}
