import 'dart:collection';

import '../utils/maps.dart';
import '../utils/range.dart';

/// Фильтр.
///
/// - По категории.
/// - По расстоянию до места.
class Filter {
  Filter({
    Set<int>? excludedCategories,
    this.distance = const Range<Distance>(Distance(0), Distance(10000)),
  }) : excludedCategories = UnmodifiableSetView<int>(excludedCategories ?? {});

  // Категории сохраняем в немодифицируемом сете, чтобы гарантировать
  // иммутабельность класса.
  final UnmodifiableSetView<int> excludedCategories;
  final Range<Distance> distance;

  bool hasCategory(int category) => !excludedCategories.contains(category);

  Filter toggleCategory(int category) {
    final exclusions = excludedCategories.toSet();
    hasCategory(category)
        ? exclusions.add(category)
        : exclusions.remove(category);
    return copyWith(excludedCategories: exclusions);
  }

  Filter copyWith({
    Set<int>? excludedCategories,
    Range<Distance>? distance,
  }) =>
      Filter(
        excludedCategories: excludedCategories == null
            ? this.excludedCategories
            : UnmodifiableSetView<int>(excludedCategories),
        distance: distance ?? this.distance,
      );
}
