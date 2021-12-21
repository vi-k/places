import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:places/data/model/filter.dart';

import 'package:places/data/model/place_base.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/repositories/place/dio_exception.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/let_and_also.dart';
import 'package:places/utils/sort.dart';

import 'api_place_mapper.dart';
import 'place_repository.dart';
import 'repository_exception.dart';

/// Репозиторий мест через api.
class ApiPlaceRepository extends PlaceRepository {
  ApiPlaceRepository(this.dio, this.mapper);

  final Dio dio;
  final ApiPlaceMapper mapper;

  /// Создаёт новое место.
  @override
  Future<int> create(PlaceBase place) async {
    try {
      final response =
          await dio.post<String>('/place', data: mapper.stringify(place));
      final newPlace = mapper.parse(response.data!);

      return newPlace.id;
    } on DioError catch (error) {
      if (error.type == DioErrorType.response &&
          error.response!.statusCode == 409) {
        throw RepositoryAlreadyExistsException();
      }

      throw createExceptionFromDio(error);
    }
  }

  /// Загружает информацию о месте.
  @override
  Future<PlaceBase> read(int id) async {
    try {
      final response = await dio.get<String>('/place/$id');

      return mapper.parse(response.data!);
    } on DioError catch (error) {
      if (error.type == DioErrorType.response &&
          error.response!.statusCode == 404) {
        throw RepositoryNotFoundException();
      }

      throw createExceptionFromDio(error);
    }
  }

  /// Обновляет информацию о месте.
  @override
  Future<void> update(PlaceBase place) async {
    try {
      await dio.put<String>(
        '/place/${place.id}',
        data: mapper.stringify(place, withId: false),
      );
    } on DioError catch (error) {
      if (error.type == DioErrorType.response &&
          error.response!.statusCode == 404) {
        throw RepositoryNotFoundException();
      }

      throw createExceptionFromDio(error);
    }
  }

  /// Удаляет место.
  @override
  Future<void> delete(int id) async {
    try {
      await dio.delete<String>('/place/$id');
    } on DioError catch (error) {
      if (error.type == DioErrorType.response &&
          error.response!.statusCode == 404) {
        throw RepositoryNotFoundException();
      }

      throw createExceptionFromDio(error);
    }
  }

  /// Загружает список мест.
  @override
  // ignore: long-parameter-list
  Future<List<PlaceBase>> loadList({
    int? count,
    int? offset,
    PlaceOrderBy? pageBy,
    Object? pageLastValue,
    Map<PlaceOrderBy, Sort>? orderBy,
  }) async {
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
            'the [orderBy] must contain the field of the [pageBy]',
          );
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
          'sortBy':
              orderBy?.entries.map((e) => '${e.key.name},${e.value.name}') ??
                  ['id,asc'],
        },
      );

      final response = await dio.getUri<String>(uri);

      return (jsonDecode(response.data!) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(mapper.map)
          .toList();
    } on DioError catch (error) {
      throw createExceptionFromDio(error);
    }
  }

  /// Загружает список мест, соответствующих фильтру.
  @override
  Future<List<PlaceBase>> loadFilteredList({
    Coord? coord,
    required Filter filter,
  }) async {
    try {
      // Если нужно получить объекты без ограничения расстояния, но, допустим,
      // по имени и типу, то придётся применять костыли. Есть ограничения
      // на радиус в нашем api (~ < 9'000'000). При больших числах он перестаёт
      // возвращать значения или возвращает только часть (причём дальние
      // объекты, а ближние пропускает). Видимо, используются формулы,
      // не рассчитанные на большие значения. Рассчитывается расстояние в этом
      // случае также неверно. Так что фильтр по расстоянию можно использовать
      // (как и предполагается по заданию) только в пределах одного города.
      // Но ведь хочется посмотреть, что там у других! А если радиус не
      // устанавливать, то работает только фильтр по названию, а по типам
      // не работает. Поэтому делаем возможность не устанавливать радиус
      // (радиус = ∞), а по типам фильтруем вручную.

      final response = await dio.post<String>(
        '/filtered_places',
        data: jsonEncode(<String, dynamic>{
          if (coord != null && filter.radius.isFinite) ...<String, dynamic>{
            'lat': coord.lat,
            'lng': coord.lon,
            'radius': filter.radius.value,
          },
          if (filter.placeTypes != null)
            'typeFilter': filter.placeTypes!.map((e) => e.name).toList(),
        }),
      );

      var tmp = (jsonDecode(response.data!) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          // Расчёт расстояния, если задана точка отсчёта.
          .map(coord?.let((it) => (e) => mapper.map(e, it)) ?? mapper.map);

      // Ручная фильтрация по типу.
      filter.placeTypes
          ?.also((it) => tmp = tmp.where((e) => it.contains(e.type)));

      return tmp.toList()..sort((a, b) => a.compareTo(b));
    } on DioError catch (error) {
      throw createExceptionFromDio(error);
    }
  }

  /// Ищет места по названию.
  @override
  Future<List<PlaceBase>> search({Coord? coord, required String text}) async {
    try {
      final response = await dio.post<String>(
        '/filtered_places',
        data: jsonEncode(<String, dynamic>{'nameFilter': text}),
      );

      final result = (jsonDecode(response.data!) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          // Расчёт расстояния, если задана точка отсчёта.
          .map(coord?.let((it) => (e) => mapper.map(e, it)) ?? mapper.map)
          .toList();

      // Сортировка по расстоянию.
      if (coord != null) result.sort();

      return result;
    } on DioError catch (error) {
      throw createExceptionFromDio(error);
    }
  }
}
