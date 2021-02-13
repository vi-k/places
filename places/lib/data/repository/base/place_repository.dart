import 'package:places/data/model/place.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/enum.dart';
import 'package:places/utils/sort.dart';

import 'filter.dart';

/// Интерфейс для репозитория мест.
///
/// Возвращает список - [list]. И производит стандартные операции (CRUD):
/// [create], [read], [update] и [delete].
abstract class PlaceRepository {
  Future<int> create(Place place);
  Future<Place> read(int id);
  Future<void> update(Place place);
  Future<void> delete(int id);

  Future<List<Place>> list(
      {int? count,
      int? offset,
      PlaceOrderBy? pageBy,
      Object? pageLastValue,
      Map<PlaceOrderBy, Sort>? orderBy});

  Future<List<Place>> filteredList({Coord? coord, required Filter filter});
}

enum PlaceOrderBy { id, name }

extension PlaceOrderByExt on PlaceOrderBy {
  String get name => nameFromEnum(this);
}
