import 'package:dio/dio.dart';

import 'dio_exception.dart';

BaseOptions createDioOptions() => BaseOptions(
      baseUrl: 'https://test-backend-flutter.surfstudio.ru',
      connectTimeout: 10000,
      receiveTimeout: 10000,
      sendTimeout: 10000,
      responseType: ResponseType.json,
    );

Dio createDio(BaseOptions options) => Dio(options)
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
      print('Получен ответ: '
          '${response.statusMessage} (${response.statusCode})');
      // print(response.data);
      handler.next(response);
    },
  ));
