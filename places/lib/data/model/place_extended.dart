import 'package:places/data/model/place.dart';

enum Favorite { no, wishlist, visited }

/// Место с доп. информацией.
class PlaceExtended extends Place {
  PlaceExtended(
    Place place, {
    required this.favorite,
    this.planToVisit,
  }) : super.from(place);

  /// Избранное: хочу посетить/посетил.
  final Favorite favorite;

  /// Запланированная дата посещения.
  final DateTime? planToVisit;
}
