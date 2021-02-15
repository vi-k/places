import 'package:places/data/model/place.dart';

/// Информация о месте, привязанная к пользователю.
class PlaceUserInfo {
  const PlaceUserInfo({
    required this.favorite,
    this.planToVisit,
  });

  /// Избранное.
  final Favorite favorite;

  /// Запланированная дата посещения.
  final DateTime? planToVisit;

  // Доп. данные не установлены.
  bool get isEmpty => planToVisit == null;

  static const PlaceUserInfo zero = PlaceUserInfo(favorite: Favorite.no);

  // Place toPlace(PlaceDto place) => Place(
  //       id: place.id,
  //       name: place.name,
  //       type: place.type,
  //       coord: place.coord,
  //       photos: place.photos,
  //       description: place.description,
  //       favorite: favorite,
  //       planToVisit: planToVisit,
  //       // this.distance = Distance.zero,
  //       // required List<String> photos,
  //     );

  @override
  String toString({bool withType = true}) => withType
      ? 'PlaceUserInfo(${toString(withType: false)})'
      : 'favorite: ${favorite.name}, planToVisit: ${planToVisit ?? '-'}';

  /// Копирует с внесением изменений.
  PlaceUserInfo copyWith({
    Favorite? favorite,
    DateTime? planToVisit,
    bool planToVisitReset = false,
  }) =>
      PlaceUserInfo(
        favorite: favorite ?? this.favorite,
        planToVisit: planToVisitReset ? null : planToVisit ?? this.planToVisit,
      );
}
