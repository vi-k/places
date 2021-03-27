import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'data/interactor/place_interactor.dart';
import 'data/model/filter.dart';
import 'data/repository/db_repository/mock_db_repository.dart';
import 'data/repository/location_repository/real_location_repository.dart';
import 'data/repository/place_repository/api_place_mapper.dart';
import 'data/repository/place_repository/api_place_repository.dart';
import 'data/repository/place_repository/dio_exception.dart';
import 'data/repository/place_repository/mock_place_repository.dart';
import 'data/repository/place_repository/repository_exception.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://test-backend-flutter.surfstudio.ru',
  connectTimeout: 10000,
  receiveTimeout: 10000,
  sendTimeout: 10000,
  responseType: ResponseType.json,
))
  ..interceptors.add(InterceptorsWrapper(
    onError: (error, handler) {
      final repositoryException = createExceptionFromDio(error);
      print(repositoryException);
      handler.next(error);
    },
    onRequest: (options, handler) {
      print('Выполняется запрос: ${options.method} ${options.uri}');
      if (options.data != null) {
        print('data: ${options.data}');
      }
      handler.next(options);
    },
    onResponse: (response, handler) {
      print(
          'Получен ответ: ${response.statusMessage} (${response.statusCode})');
      // print(response.data);
      handler.next(response);
    },
  ));

Future<void> main() async {
  // await moveFromMockToRepository();
  // await testPlaceRepository();

  Intl.defaultLocale = 'ru_RU';

  runApp(App());
}

// Перенос мест из моковых в БД
Future<void> moveFromMockToRepository() async {
  final placeRepository = ApiPlaceRepository(dio, ApiPlaceMapper());
  final mocksRepository = MockPlaceRepository();
  final mocksList = await mocksRepository.loadList();
  for (final place in mocksList) {
    try {
      await placeRepository.create(place);
    } on RepositoryAlreadyExistsException {
      await placeRepository.update(place);
    }
  }
}

Future<void> testPlaceRepository() async {
  final placeRepository = ApiPlaceRepository(dio, ApiPlaceMapper());
  final dbRepository = MockDbRepository();
  final locationRepository = RealLocationRepository();
  final placeInteractor = PlaceInteractor(
    placeRepository: placeRepository,
    dbRepository: dbRepository,
    locationRepository: locationRepository,
  );
  final list = await placeInteractor.getPlaces(Filter());
  print(list);

  // final places = await placeRepository.loadFilteredList(
  //   coord: locationRepository.location, filter: Filter());
  // print(places);
}
