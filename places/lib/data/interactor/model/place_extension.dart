import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_extended.dart';

/// Доп. информация о месте.
///
/// Повторяет доп. часть из [PlaceExtended].
class PlaceExtension {
  const PlaceExtension(
    this.favorite, [
    this.planToVisit,
  ]);

  PlaceExtension.from(PlaceExtended place)
      : this(place.favorite, place.planToVisit);

  /// Избранное: хочу посетить/посетил.
  final Favorite favorite;

  /// Запланированная дата посещения.
  final DateTime? planToVisit;

  bool get isEmpty => planToVisit == null;

  static const PlaceExtension zero = PlaceExtension(Favorite.no);

  PlaceExtended toPlaceExtended(Place place) =>
      PlaceExtended(place, favorite: favorite, planToVisit: planToVisit);

  /// Копирует с внесением изменений.
  PlaceExtension copyWith(
          {Favorite? favorite,
          DateTime? planToVisit,
          bool planToVisitReset = false}) =>
      PlaceExtension(
        favorite ?? this.favorite,
        planToVisitReset ? null : planToVisit ?? this.planToVisit,
      );
}
