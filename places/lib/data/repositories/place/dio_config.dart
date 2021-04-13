import 'package:dio/dio.dart';
import 'package:places/logger.dart';

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
      logger.d(repositoryException);
      handler.next(error);
    },
    onRequest: (options, handler) {
      logger.d('Выполняется запрос: ${options.method} ${options.uri}');
      final dynamic data = options.data;
      if (data != null) {
        if (data is FormData) {
          logger.d(data.fields);
        } else {
          logger.d('data: $data');
        }
      }
      handler.next(options);
    },
    onResponse: (response, handler) {
      logger.d('Получен ответ: '
          '${response.statusMessage} (${response.statusCode})');
      handler.next(response);
    },
  ));
