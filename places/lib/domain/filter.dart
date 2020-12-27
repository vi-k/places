import 'dart:collection';

import '../utils/maps.dart';
import '../utils/range.dart';
import 'sight.dart';

/// Фильтр.
///
/// - По категории.
/// - По расстоянию до места.
class Filter {
  Filter({
    Set<SightCategory>? categories,
    this.distance = const Range<Distance>(Distance(0), Distance(10000)),
  }) : categories = UnmodifiableSetView<SightCategory>(
            categories ?? {...SightCategory.values});

  // Категории сохраняем в немодифицируемом сете, чтобы гарантировать
  // иммутабельность класса.
  final UnmodifiableSetView<SightCategory> categories;
  final Range<Distance> distance;

  bool hasCategory(SightCategory type) => categories.contains(type);

  Filter toggleCategory(SightCategory type) {
    final s = categories.toSet();
    hasCategory(type) ? s.remove(type) : s.add(type);
    return copyWith(categories: s);
  }

  Filter copyWith({
    Set<SightCategory>? categories,
    Range<Distance>? distance,
  }) =>
      Filter(
        categories: categories == null
            ? this.categories
            : UnmodifiableSetView<SightCategory>(categories),
        distance: distance ?? this.distance,
      );
}
