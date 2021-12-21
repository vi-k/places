import 'package:json_annotation/json_annotation.dart';

class DoubleConverter implements JsonConverter<double, Object> {
  const DoubleConverter();

  @override
  double fromJson(Object json) {
    if (json is double) return json;

    if (json is String) {
      if (json == '-infinity') return double.negativeInfinity;
      if (json == 'infinity') return double.infinity;
      if (json == 'nan') return double.nan;

      return double.parse(json);
    }

    throw Exception('Invalid input for double');
  }

  @override
  String toJson(double value) {
    if (value == double.negativeInfinity) return '-infinity';
    if (value == double.infinity) return 'infinity';
    if (value.isNaN) return 'nan';

    return value.toString();
  }
}
