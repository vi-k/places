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

  SearchHistoryCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryCompanion(
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

class SearchHistoryCompanion extends UpdateCompanion<SearchHistoryEntity> {
  final Value<String> request;
  final Value<DateTime> timestamp;
  final Value<int> count;
  const SearchHistoryCompanion({
    this.request = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.count = const Value.absent(),
  });
  SearchHistoryCompanion.insert({
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

  SearchHistoryCompanion copyWith(
      {Value<String>? request, Value<DateTime>? timestamp, Value<int>? count}) {
    return SearchHistoryCompanion(
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
    return (StringBuffer('SearchHistoryCompanion(')
          ..write('request: $request, ')
          ..write('timestamp: $timestamp, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTable extends SearchHistory
    with TableInfo<$SearchHistoryTable, SearchHistoryEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $SearchHistoryTable(this._db, [this._alias]);
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
  $SearchHistoryTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'search_history';
  @override
  final String actualTableName = 'search_history';
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
  $SearchHistoryTable createAlias(String alias) {
    return $SearchHistoryTable(_db, alias);
  }
}

class PlacesInfoEntity extends DataClass
    implements Insertable<PlacesInfoEntity> {
  final int placeId;
  final int favorite;
  final DateTime? planToVisit;
  PlacesInfoEntity(
      {required this.placeId, required this.favorite, this.planToVisit});
  factory PlacesInfoEntity.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return PlacesInfoEntity(
      placeId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}place_id'])!,
      favorite:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}favorite'])!,
      planToVisit: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}plan_to_visit']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<int>(placeId);
    map['favorite'] = Variable<int>(favorite);
    if (!nullToAbsent || planToVisit != null) {
      map['plan_to_visit'] = Variable<DateTime?>(planToVisit);
    }
    return map;
  }

  PlacesInfoCompanion toCompanion(bool nullToAbsent) {
    return PlacesInfoCompanion(
      placeId: Value(placeId),
      favorite: Value(favorite),
      planToVisit: planToVisit == null && nullToAbsent
          ? const Value.absent()
          : Value(planToVisit),
    );
  }

  factory PlacesInfoEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PlacesInfoEntity(
      placeId: serializer.fromJson<int>(json['placeId']),
      favorite: serializer.fromJson<int>(json['favorite']),
      planToVisit: serializer.fromJson<DateTime?>(json['planToVisit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<int>(placeId),
      'favorite': serializer.toJson<int>(favorite),
      'planToVisit': serializer.toJson<DateTime?>(planToVisit),
    };
  }

  PlacesInfoEntity copyWith(
          {int? placeId, int? favorite, DateTime? planToVisit}) =>
      PlacesInfoEntity(
        placeId: placeId ?? this.placeId,
        favorite: favorite ?? this.favorite,
        planToVisit: planToVisit ?? this.planToVisit,
      );
  @override
  String toString() {
    return (StringBuffer('PlacesInfoEntity(')
          ..write('placeId: $placeId, ')
          ..write('favorite: $favorite, ')
          ..write('planToVisit: $planToVisit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(placeId.hashCode, $mrjc(favorite.hashCode, planToVisit.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PlacesInfoEntity &&
          other.placeId == this.placeId &&
          other.favorite == this.favorite &&
          other.planToVisit == this.planToVisit);
}

class PlacesInfoCompanion extends UpdateCompanion<PlacesInfoEntity> {
  final Value<int> placeId;
  final Value<int> favorite;
  final Value<DateTime?> planToVisit;
  const PlacesInfoCompanion({
    this.placeId = const Value.absent(),
    this.favorite = const Value.absent(),
    this.planToVisit = const Value.absent(),
  });
  PlacesInfoCompanion.insert({
    this.placeId = const Value.absent(),
    required int favorite,
    this.planToVisit = const Value.absent(),
  }) : favorite = Value(favorite);
  static Insertable<PlacesInfoEntity> custom({
    Expression<int>? placeId,
    Expression<int>? favorite,
    Expression<DateTime?>? planToVisit,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (favorite != null) 'favorite': favorite,
      if (planToVisit != null) 'plan_to_visit': planToVisit,
    });
  }

  PlacesInfoCompanion copyWith(
      {Value<int>? placeId,
      Value<int>? favorite,
      Value<DateTime?>? planToVisit}) {
    return PlacesInfoCompanion(
      placeId: placeId ?? this.placeId,
      favorite: favorite ?? this.favorite,
      planToVisit: planToVisit ?? this.planToVisit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<int>(favorite.value);
    }
    if (planToVisit.present) {
      map['plan_to_visit'] = Variable<DateTime?>(planToVisit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesInfoCompanion(')
          ..write('placeId: $placeId, ')
          ..write('favorite: $favorite, ')
          ..write('planToVisit: $planToVisit')
          ..write(')'))
        .toString();
  }
}

class $PlacesInfoTable extends PlacesInfo
    with TableInfo<$PlacesInfoTable, PlacesInfoEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PlacesInfoTable(this._db, [this._alias]);
  final VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedIntColumn placeId = _constructPlaceId();
  GeneratedIntColumn _constructPlaceId() {
    return GeneratedIntColumn(
      'place_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _favoriteMeta = const VerificationMeta('favorite');
  @override
  late final GeneratedIntColumn favorite = _constructFavorite();
  GeneratedIntColumn _constructFavorite() {
    return GeneratedIntColumn(
      'favorite',
      $tableName,
      false,
    );
  }

  final VerificationMeta _planToVisitMeta =
      const VerificationMeta('planToVisit');
  @override
  late final GeneratedDateTimeColumn planToVisit = _constructPlanToVisit();
  GeneratedDateTimeColumn _constructPlanToVisit() {
    return GeneratedDateTimeColumn(
      'plan_to_visit',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [placeId, favorite, planToVisit];
  @override
  $PlacesInfoTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'places_info';
  @override
  final String actualTableName = 'places_info';
  @override
  VerificationContext validateIntegrity(Insertable<PlacesInfoEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta,
          favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    } else if (isInserting) {
      context.missing(_favoriteMeta);
    }
    if (data.containsKey('plan_to_visit')) {
      context.handle(
          _planToVisitMeta,
          planToVisit.isAcceptableOrUnknown(
              data['plan_to_visit']!, _planToVisitMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId};
  @override
  PlacesInfoEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PlacesInfoEntity.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PlacesInfoTable createAlias(String alias) {
    return $PlacesInfoTable(_db, alias);
  }
}

abstract class _$SqliteDbRepository extends GeneratedDatabase {
  _$SqliteDbRepository(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  late final $SearchHistoryTable searchHistory = $SearchHistoryTable(this);
  late final Index timestampIndex = Index('timestamp_index',
      'CREATE INDEX IF NOT EXISTS timestamp_index ON search_history (timestamp);');
  late final $PlacesInfoTable placesInfo = $PlacesInfoTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [searchHistory, timestampIndex, placesInfo];
}
