part of 'sqlite_db_repository.dart';

/// Таблицы БД.
@DataClassName('SearchHistoryEntity')
class SearchHistory extends Table {
  TextColumn get request => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get count => integer()();

  @override
  Set<Column>? get primaryKey => {request};
}

@DataClassName('PlacesInfoEntity')
class PlacesInfo extends Table {
  IntColumn get placeId => integer()();
  IntColumn get favorite => integer()();
  DateTimeColumn get planToVisit => dateTime().nullable()();

  @override
  Set<Column>? get primaryKey => {placeId};
}
