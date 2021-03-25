import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'data/repository/api_place_mapper.dart';
import 'data/repository/api_place_repository.dart';
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
    onError: (error, handler) {
      final repositoryException = createExceptionFromDio(error);
      print(repositoryException);
      handler.next(error);
    },
    onRequest: (options, handler) {
      print('Выполняется запрос: ${options.method} ${options.uri}');
      if (options.data != null) {
        print('data: ${options.data}');
        handler.next(options);
      }
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
