import 'package:places/data/model/place_type.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/let_and_also.dart';

/// Фильтр.
///
/// - По расстоянию до места.
/// - По типу места.
/// - По названию.
class Filter {
  Filter({
    this.radius = const Distance(double.infinity),
    Set<PlaceType>? placeTypes,
    this.nameFilter = '',
  }) : placeTypes = placeTypes?.let((it) => Set.unmodifiable(placeTypes)) ??
            PlaceType.values.toSet();

  /// Радиус поиска.
  final Distance radius;

  /// Типы мест.
  ///
  /// Если `null`, то все.
  final Set<PlaceType> placeTypes;

  /// Фильтр по названию.
  final String nameFilter;

  bool hasPlaceType(PlaceType placeType) => placeTypes.contains(placeType);

  Filter togglePlaceType(PlaceType placeType) {
    final newPlaceTypes = placeTypes.toSet();

    newPlaceTypes.contains(placeType)
        ? newPlaceTypes.remove(placeType)
        : newPlaceTypes.add(placeType);
    return copyWith(placeTypes: newPlaceTypes);
  }

  Filter copyWith(
          {Set<PlaceType>? placeTypes, Distance? radius, String? nameFilter}) =>
      Filter(
        placeTypes: placeTypes ?? this.placeTypes,
        radius: radius ?? this.radius,
        nameFilter: nameFilter ?? this.nameFilter,
      );

  @override
  String toString() => 'Filter(radius: $radius, '
      'placeTypes: $placeTypes, '
      'nameFilter: $nameFilter)';
}
