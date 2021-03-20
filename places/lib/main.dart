import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'data/interactor/place_interactor.dart';
import 'data/model/place_base.dart';
import 'data/repository/api_place_mapper.dart';
import 'data/repository/api_place_repository.dart';
import 'data/repository/base/location_repository.dart';
import 'data/repository/base/mock_location_repository.dart';
import 'data/repository/base/place_repository.dart';
import 'data/repository/dio_exception.dart';
import 'data/repository/mock_place_repository.dart';
import 'data/repository/repository_exception.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://test-backend-flutter.surfstudio.ru',
  connectTimeout: 5000,
  receiveTimeout: 5000,
  sendTimeout: 5000,
  responseType: ResponseType.json,
))
  ..interceptors.add(InterceptorsWrapper(
    onError: (error) {
      final repositoryException = createExceptionFromDio(error);
      print(repositoryException);
    },
    onRequest: (options) {
      print('Выполняется запрос: ${options.method} ${options.uri}');
      if (options.data != null) {
        print('data: ${options.data}');
      }
    },
    onResponse: (response) {
      print(
          'Получен ответ: ${response.statusMessage} (${response.statusCode})');
      // print(response.data);
    },
  ));

Future<void> main() async {
  // await moveFromMockToRepository();
  // await testPlaceRepository();

  // await initializeDateFormatting('ru_RU', null);
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
