import 'dart:collection';

import '../utils/maps.dart';
import '../utils/range.dart';
import 'sight.dart';

class Filter {
  Filter({
    Set<SightType>? categories,
    this.distance = const Range<Distance>(Distance(0), Distance(10000)),
  }) : categories =
            UnmodifiableSetView<SightType>(categories ?? {...SightType.values});

  final UnmodifiableSetView<SightType> categories;
  final Range<Distance> distance;

  bool hasCategory(SightType type) => categories.contains(type);

  Filter toggleCategory(SightType type) {
    final s = categories.toSet();
    hasCategory(type) ? s.remove(type) : s.add(type);
    return copyWith(categories: s);
  }

  Filter copyWith({Set<SightType>? categories, Range<Distance>? distance}) =>
      Filter(
        categories: categories == null
            ? this.categories
            : UnmodifiableSetView<SightType>(categories),
        distance: distance ?? this.distance,
      );
}
