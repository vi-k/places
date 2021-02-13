import 'dart:collection';

import 'package:places/utils/coord.dart';

/// Интересное место.
class Sight {
  Sight({
    required this.id,
    required this.name,
    required this.coord,
    required List<String> photos,
    required this.details,
    required this.categoryId,
    this.visited = false,
    this.visitDate,
    this.visitedDate,
  }) : photos = UnmodifiableListView(photos);

  final int id;
  final String name;
  final Coord coord;
  final UnmodifiableListView<String> photos;
  final String details;
  final int categoryId;
  final bool visited;
  final DateTime? visitDate;
  final DateTime? visitedDate;

  @override
  String toString() => 'Sight(id: $id, $name, $categoryId, $coord ...)';

  Sight copyWith({
    int? id,
    String? name,
    Coord? coord,
    List<String>? photos,
    String? details,
    int? categoryId,
    bool? visited,
    DateTime? visitDate,
    DateTime? visitedDate,
  }) =>
      Sight(
        id: id ?? this.id,
        name: name ?? this.name,
        coord: coord ?? this.coord,
        photos: photos ?? this.photos,
        details: details ?? this.details,
        categoryId: categoryId ?? this.categoryId,
        visited: visited ?? this.visited,
        visitDate: visitDate ?? this.visitDate,
        visitedDate: visitedDate ?? this.visitedDate,
      );
}
