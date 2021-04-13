import 'package:equatable/equatable.dart';
import 'package:places/data/model/place.dart';

/// Информация о месте, привязанная к пользователю.
class PlaceUserInfo extends Equatable {
  const PlaceUserInfo({
    required this.favorite,
    this.planToVisit,
  });

  /// Избранное.
  final Favorite favorite;

  /// Запланированная дата посещения.
  final DateTime? planToVisit;

  @override
  List<Object?> get props => [favorite, planToVisit];

  // Доп. данные не установлены.
  bool get isEmpty => planToVisit == null;

  static const PlaceUserInfo zero = PlaceUserInfo(favorite: Favorite.no);

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
