import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:places/data/model/place_base.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/sort.dart';

import 'base/filter.dart';
import 'base/place_repository.dart';
import 'repository_exception.dart';

/// Репозиторий мест через api.
class ApiPlaceRepository extends PlaceRepository {
  ApiPlaceRepository(this.dio);

  final Dio dio;

  PlaceBase _fromString(String value) =>
      _fromMap(jsonDecode(value) as Map<String, dynamic>);

  PlaceBase _fromMap(Map<String, dynamic> value, [Coord? calDistanceFrom]) => PlaceBase(
        id: value['id'] as int,
        coord: Coord(value['lat'] as double, value['lng'] as double),
        name: value['name'] as String,
        photos: (value['urls'] as List<dynamic>).whereType<String>().toList(),
        type: placeTypeByName(value['placeType'] as String)!,
        description: value['description'] as String,
        calDistanceFrom: calDistanceFrom,
      );

  String _toString(PlaceBase value, {bool withId = true}) {
    final obj = <String, dynamic>{
      if (withId && value.id != 0) 'id': value.id,
      'lat': value.coord.lat,
      'lng': value.coord.lon,
      'name': value.name,
      'urls': value.photos,
      'placeType': value.type.name,
      'description': value.description,
    };
    return jsonEncode(obj);
  }

  /// Создаёт новое место.
  @override
  Future<int> create(PlaceBase place) async {
    try {
      final response = await dio.post<String>('/place', data: _toString(place));
      final newPlace = _fromString(response.data);
      return newPlace.id;
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE && e.response.statusCode == 409) {
        throw RepositoryAlreadyExistsException();
      }

      final error = RepositoryException.fromDio(e);
      if (error == null) rethrow;
      throw error;
    }
  }

  /// Загружает информацию о месте.
  @override
  Future<PlaceBase> read(int id) async {
    try {
      final response = await dio.get<String>('/place/$id');
      return _fromString(response.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE && e.response.statusCode == 404) {
        throw RepositoryNotFoundException();
      }

      final error = RepositoryException.fromDio(e);
      if (error == null) rethrow;
      throw error;
    }
  }

  /// Обновляет информацию о месте.
  @override
  Future<void> update(PlaceBase place) async {
    try {
      await dio.put<String>('/place/${place.id}',
          data: _toString(place, withId: false));
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE && e.response.statusCode == 404) {
        throw RepositoryNotFoundException();
      }

      final error = RepositoryException.fromDio(e);
      if (error == null) rethrow;
      throw error;
    }
  }

  /// Удаляет место.
  @override
  Future<void> delete(int id) async {
    try {
      await dio.delete<String>('/place/$id');
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE && e.response.statusCode == 404) {
        throw RepositoryNotFoundException();
      }

      final error = RepositoryException.fromDio(e);
      if (error == null) rethrow;
      throw error;
    }
  }

  /// Загружает список мест.
  @override
  Future<List<PlaceBase>> list(
      {int? count,
      int? offset,
      PlaceOrderBy? pageBy,
      Object? pageLastValue,
      Map<PlaceOrderBy, Sort>? orderBy}) async {
    try {
      String? pageByDirect;
      if (pageBy != null) {
        if (pageLastValue == null) {
          throw RepositoryException('the [pageLastValue] is expected');
        }
        if (orderBy == null) {
          throw RepositoryException('the [orderBy] is expected');
        }
        final sort = orderBy[pageBy];
        if (sort == null) {
          throw RepositoryException(
              'the [orderBy] must contain the field of the [pageBy]');
        }

        pageByDirect = sort == Sort.asc ? 'pageAfter' : 'pagePrior';
      }

      // При формировании запроса через функцию get, почему-то массив
      // в queryParameters превращается в sortBy[]=..&sortBy[]=..
      // А через Uri как надо: sortBy=..&sortBy=
      final uri = Uri(
        path: '/place',
        queryParameters: <String, dynamic>{
          if (count != null) 'count': count.toString(),
          if (offset != null) 'offset': offset.toString(),
          if (pageBy != null) 'pageBy': pageBy.name,
          if (pageByDirect != null) pageByDirect: pageLastValue.toString(),
          'sortBy': orderBy == null
              ? ['id,asc']
              : orderBy.entries.map((e) => '${e.key.name},${e.value.name}')
        },
      );

      final response = await dio.getUri<String>(uri);
      return (jsonDecode(response.data) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(_fromMap)
          .toList();
    } on DioError catch (e) {
      final error = RepositoryException.fromDio(e);
      if (error == null) rethrow;
      throw error;
    }
  }

  /// Загружает список мест, соответствующих фильтру.
  @override
  Future<List<PlaceBase>> filteredList(
      {Coord? coord, required Filter filter}) async {
    try {
      /// Если нужно получить объекты без ограничения расстояния, но, допустим,
      /// по имени и типу, то придётся применять костыли. Есть ограничения
      /// на радиус в нашем api (~ < 9'000'000). При больших числах он перестаёт
      /// возвращать значения или возвращает только часть (причём дальние
      /// объекты, а ближние пропускает). Видимо, используются формулы,
      /// не рассчитанные на большие значения. Рассчитывается расстояние в этом
      /// случае также неверно. Так что фильтр по расстоянию можно использовать
      /// (как и предполагается по заданию) только в пределах одного города.
      /// Но ведь хочется посмотреть, что там у других! А если радиус не
      /// устанавливать, то работает только фильтр по названию, а по типам
      /// не работает. Поэтому делаем возможность не устанавливать радиус
      /// (радиус = ∞), а по типам фильтруем вручную.

      final response = await dio.post<String>('/filtered_places',
          data: jsonEncode(<String, dynamic>{
            if (coord != null && filter.radius.isFinite) ...<String, dynamic>{
              'lat': coord.lat,
              'lng': coord.lon,
              'radius': filter.radius.value,
            },
            'typeFilter': filter.placeTypes.map((e) => e.name).toList(),
            'nameFilter': filter.nameFilter,
          }));

      final from = coord;
      return (jsonDecode(response.data) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(from == null ? _fromMap : (e) => _fromMap(e, from))
          // Ручная фильтрация по типу.
          .where((e) => filter.placeTypes.contains(e.type))
          .toList()
            ..sort((a, b) => a.distance.compareTo(b.distance));
    } on DioError catch (e) {
      final error = RepositoryException.fromDio(e);
      if (error == null) rethrow;
      throw error;
    }
  }
}
