import 'package:places/data/model/place_type.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/let_and_also.dart';

/// Фильтр по расстоянию до места и типу места.
class Filter {
  Filter({
    this.radius = const Distance(double.infinity),
    Set<PlaceType>? placeTypes,
  }) : placeTypes =
            placeTypes?.let((it) => Set<PlaceType>.unmodifiable(placeTypes));

  /// Радиус поиска.
  final Distance radius;

  /// Типы мест.
  ///
  /// Если `null`, то все.
  final Set<PlaceType>? placeTypes;

  bool hasPlaceType(PlaceType placeType) =>
      placeTypes?.contains(placeType) ?? true;

  Filter togglePlaceType(PlaceType placeType) {
    final newPlaceTypes = placeTypes?.toSet() ?? PlaceType.values.toSet();

    if (newPlaceTypes.contains(placeType)) {
      newPlaceTypes.remove(placeType);
    } else {
      newPlaceTypes.add(placeType);
    }

    return newPlaceTypes.length == PlaceType.values.length
        ? copyWith(placeTypesReset: true)
        : copyWith(placeTypes: newPlaceTypes);
  }

  Filter copyWith({
    Set<PlaceType>? placeTypes,
    bool placeTypesReset = false,
    Distance? radius,
  }) {
    assert(placeTypes == null || placeTypesReset == false);
    return Filter(
      placeTypes: placeTypesReset ? null : placeTypes ?? this.placeTypes,
      radius: radius ?? this.radius,
    );
  }

  @override
  String toString() => 'Filter(radius: $radius, placeTypes: $placeTypes)';
}
