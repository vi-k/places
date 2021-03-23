// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sqlite_db_repository.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class SearchHistoryEntity extends DataClass
    implements Insertable<SearchHistoryEntity> {
  final String request;
  final DateTime timestamp;
  final int count;
  SearchHistoryEntity(
      {required this.request, required this.timestamp, required this.count});
  factory SearchHistoryEntity.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return SearchHistoryEntity(
      request: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}request'])!,
      timestamp: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}timestamp'])!,
      count: intType.mapFromDatabaseResponse(data['${effectivePrefix}count'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['request'] = Variable<String>(request);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['count'] = Variable<int>(count);
    return map;
  }

  SearchHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryTableCompanion(
      request: Value(request),
      timestamp: Value(timestamp),
      count: Value(count),
    );
  }

  factory SearchHistoryEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SearchHistoryEntity(
      request: serializer.fromJson<String>(json['request']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'request': serializer.toJson<String>(request),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'count': serializer.toJson<int>(count),
    };
  }

  SearchHistoryEntity copyWith(
          {String? request, DateTime? timestamp, int? count}) =>
      SearchHistoryEntity(
        request: request ?? this.request,
        timestamp: timestamp ?? this.timestamp,
        count: count ?? this.count,
      );
  @override
  String toString() {
    return (StringBuffer('SearchHistoryEntity(')
          ..write('request: $request, ')
          ..write('timestamp: $timestamp, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(request.hashCode, $mrjc(timestamp.hashCode, count.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SearchHistoryEntity &&
          other.request == this.request &&
          other.timestamp == this.timestamp &&
          other.count == this.count);
}

class SearchHistoryTableCompanion extends UpdateCompanion<SearchHistoryEntity> {
  final Value<String> request;
  final Value<DateTime> timestamp;
  final Value<int> count;
  const SearchHistoryTableCompanion({
    this.request = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.count = const Value.absent(),
  });
  SearchHistoryTableCompanion.insert({
    required String request,
    required DateTime timestamp,
    required int count,
  })   : request = Value(request),
        timestamp = Value(timestamp),
        count = Value(count);
  static Insertable<SearchHistoryEntity> custom({
    Expression<String>? request,
    Expression<DateTime>? timestamp,
    Expression<int>? count,
  }) {
    return RawValuesInsertable({
      if (request != null) 'request': request,
      if (timestamp != null) 'timestamp': timestamp,
      if (count != null) 'count': count,
    });
  }

  SearchHistoryTableCompanion copyWith(
      {Value<String>? request, Value<DateTime>? timestamp, Value<int>? count}) {
    return SearchHistoryTableCompanion(
      request: request ?? this.request,
      timestamp: timestamp ?? this.timestamp,
      count: count ?? this.count,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (request.present) {
      map['request'] = Variable<String>(request.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryTableCompanion(')
          ..write('request: $request, ')
          ..write('timestamp: $timestamp, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTableTable extends SearchHistoryTable
    with TableInfo<$SearchHistoryTableTable, SearchHistoryEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $SearchHistoryTableTable(this._db, [this._alias]);
  final VerificationMeta _requestMeta = const VerificationMeta('request');
  @override
  late final GeneratedTextColumn request = _constructRequest();
  GeneratedTextColumn _constructRequest() {
    return GeneratedTextColumn(
      'request',
      $tableName,
      false,
    );
  }

  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  @override
  late final GeneratedDateTimeColumn timestamp = _constructTimestamp();
  GeneratedDateTimeColumn _constructTimestamp() {
    return GeneratedDateTimeColumn(
      'timestamp',
      $tableName,
      false,
    );
  }

  final VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedIntColumn count = _constructCount();
  GeneratedIntColumn _constructCount() {
    return GeneratedIntColumn(
      'count',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [request, timestamp, count];
  @override
  $SearchHistoryTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'search_history_table';
  @override
  final String actualTableName = 'search_history_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SearchHistoryEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('request')) {
      context.handle(_requestMeta,
          request.isAcceptableOrUnknown(data['request']!, _requestMeta));
    } else if (isInserting) {
      context.missing(_requestMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {request};
  @override
  SearchHistoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SearchHistoryEntity.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SearchHistoryTableTable createAlias(String alias) {
    return $SearchHistoryTableTable(_db, alias);
  }
}

abstract class _$SqliteDbRepository extends GeneratedDatabase {
  _$SqliteDbRepository(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  late final Index timestampIndex = Index('timestamp_index',
      'CREATE INDEX IF NOT EXISTS timestamp_index ON search_history (timestamp);');
  late final $SearchHistoryTableTable searchHistoryTable =
      $SearchHistoryTableTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [timestampIndex, searchHistoryTable];
}
