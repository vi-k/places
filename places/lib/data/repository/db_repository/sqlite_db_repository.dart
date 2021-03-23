import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:places/data/model/search_request.dart';
import 'package:places/data/repository/db_repository/db_repository.dart';

part 'sqlite_db_repository.g.dart';
part 'sqlite_db_tables.dart';

/// Реализация БД через SQLite.
@UseMoor(
  tables: [SearchHistoryTable],
  include: {
    'sqlite_db_indices.moor',
  },
)
class SqliteDbRepository extends _$SqliteDbRepository with DbRepository {
  SqliteDbRepository() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  Future<List<SearchRequest>> getSearchHistory() async {
    final entities = await (select(searchHistoryTable)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.timestamp,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
    return entities
        .map((e) => SearchRequest(
              e.request,
              timestamp: e.timestamp,
              count: e.count,
            ))
        .toList();
  }

  @override
  Future<void> saveSearchRequest(SearchRequest query) async {
    await into(searchHistoryTable)
        .insertOnConflictUpdate(SearchHistoryTableCompanion.insert(
      request: query.text,
      timestamp: query.timestamp,
      count: query.count,
    ));
  }

  @override
  Future<void> clearSearchHistory() async {
    await delete(searchHistoryTable).go();
  }

  @override
  Future<void> deleteSearchRequest(String request) async {
    await (delete(searchHistoryTable)
          ..where((tbl) => tbl.request.equals(request)))
        .go();
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dbPath = await getApplicationDocumentsDirectory();
      final file = File(join(dbPath.path, 'db.sqlite'));
      return VmDatabase(file);
    });
