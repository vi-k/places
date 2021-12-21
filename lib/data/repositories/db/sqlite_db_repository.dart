import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/model/search_request.dart';
import 'package:places/data/repositories/db/db_repository.dart';
import 'package:places/utils/let_and_also.dart';

part 'sqlite_db_repository.g.dart';
part 'sqlite_db_tables.dart';

/// Реализация БД через SQLite.
@UseMoor(
  tables: [SearchHistory, PlacesInfo],
  include: {
    'sqlite_db_indices.moor',
  },
)
// ignore: prefer_mixin
class SqliteDbRepository extends _$SqliteDbRepository with DbRepository {
  SqliteDbRepository() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  Future<List<SearchRequest>> getSearchHistory() async {
    final entities = await (select(searchHistory)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.timestamp,
                  mode: OrderingMode.desc,
                ),
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
  Future<void> saveSearchRequest(SearchRequest request) =>
      into(searchHistory).insertOnConflictUpdate(SearchHistoryCompanion.insert(
        request: request.text,
        timestamp: request.timestamp,
        count: request.count,
      ));

  @override
  Future<void> clearSearchHistory() => delete(searchHistory).go();

  @override
  Future<void> deleteSearchRequest(String requestText) =>
      (delete(searchHistory)..where((t) => t.request.equals(requestText))).go();

  @override
  Future<Map<int, PlaceUserInfo>> getFavorites(Favorite type) async {
    final entities = await (select(placesInfo)
          ..where((t) => t.favorite.equals(type.index)))
        .get();

    return Map<int, PlaceUserInfo>.fromEntries(entities.map((e) => MapEntry(
          e.placeId,
          PlaceUserInfo(
            favorite: Favorite.values[e.favorite],
            planToVisit: e.planToVisit,
          ),
        )));
  }

  @override
  Future<PlaceUserInfo?> loadPlaceUserInfo(int placeId) async {
    final entity = await (select(placesInfo)
          ..where((t) => t.placeId.equals(placeId)))
        .getSingleOrNull();

    return entity?.let((it) => PlaceUserInfo(
          favorite: Favorite.values[it.favorite],
          planToVisit: it.planToVisit,
        ));
  }

  @override
  Future<void> updatePlaceUserInfo(int placeId, PlaceUserInfo userInfo) async {
    if (userInfo.favorite == Favorite.no && userInfo.isEmpty) {
      await (delete(placesInfo)..where((t) => t.placeId.equals(placeId))).go();
    } else {
      await into(placesInfo).insertOnConflictUpdate(PlacesInfoCompanion.insert(
        placeId: Value(placeId),
        favorite: userInfo.favorite.index,
        planToVisit: Value(userInfo.planToVisit),
      ));
    }
  }

  @override
  Future<void> removePlaceUserInfo(int placeId) =>
      (delete(placesInfo)..where((t) => t.placeId.equals(placeId))).go();
}

LazyDatabase _openConnection() => LazyDatabase(
      () async {
        // final dbPath = await getApplicationDocumentsDirectory();
        final dbPath = await getExternalStorageDirectory();
        final file = File(join(dbPath!.path, 'db.sqlite'));

        return VmDatabase(file);
        // return VmDatabase(file, logStatements: true);
      },
    );
