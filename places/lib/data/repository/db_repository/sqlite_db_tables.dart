part of 'sqlite_db_repository.dart';

/// Таблицы БД.
@DataClassName('SearchHistoryEntity')
class SearchHistoryTable extends Table {
  TextColumn get request => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get count => integer()();

  @override
  Set<Column>? get primaryKey => {request};
}
