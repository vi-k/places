// @dart=2.9
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'app.dart';

final dio = Dio(BaseOptions(
  // baseUrl: 'https://test-backend-flutter.surfstudio.ru',
  connectTimeout: 5000,
  receiveTimeout: 5000,
  sendTimeout: 5000,
  responseType: ResponseType.json,
))
  ..interceptors.add(InterceptorsWrapper(
    onError: (error) {
      print('Ошибка: ${error.message}');
    },
    onRequest: (options) {
      print('Запрос: ${options.uri}');
    },
    onResponse: (response) {
      print('Получен ответ: ${response.statusMessage}');
    },
  ));

Future<void> main() async {
  final response = await dio.get<String>(
    'https://jsonplaceholder.typicode.com/users',
    queryParameters: <String, dynamic>{'id': 1},
  );
  print(response);

  runApp(App());
}
