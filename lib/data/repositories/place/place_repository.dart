import 'package:places/data/model/filter.dart';
import 'package:places/data/model/place_base.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/enum.dart';
import 'package:places/utils/sort.dart';

/// Интерфейс для репозитория мест.
///
/// Возвращает список - [loadList]. И производит стандартные операции (CRUD):
/// [create], [read], [update] и [delete].
abstract class PlaceRepository {
  Future<int> create(PlaceBase place);
  Future<PlaceBase> read(int id);
  Future<void> update(PlaceBase place);
  Future<void> delete(int id);

  Future<List<PlaceBase>> loadList({
    int? count,
    int? offset,
    PlaceOrderBy? pageBy,
    Object? pageLastValue,
    Map<PlaceOrderBy, Sort>? orderBy,
  });

  Future<List<PlaceBase>> loadFilteredList({
    Coord? coord,
    required Filter filter,
  });

  Future<List<PlaceBase>> search({Coord? coord, required String text});
}

enum PlaceOrderBy { id, name }

extension PlaceOrderByExt on PlaceOrderBy {
  String get name => enumName(this);
}
