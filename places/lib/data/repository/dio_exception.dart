import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';

import 'repository_exception.dart';
import 'repository_network_exception.dart';

String _messageFromJson(Map<String, dynamic> json) =>
    json.containsKey('reasons')
        ? '${json['error']}: '
            '${(json['reasons'] as List<dynamic>).join(', ')}'
        : json['error'].toString();

RepositoryException createExceptionFromDio(DioError error) {
  var message = error.message;

  if (error.type == DioErrorType.RESPONSE) {
    final dynamic data = error.response?.data;
    if (data != null && data is String) {
      if (data.isEmpty) message = 'no description';

      try {
        message = _messageFromJson(jsonDecode(data) as Map<String, dynamic>);
      } on FormatException catch (_) {
        message = 'unknown error: "$data"';
      }
    }
  }

  return RepositoryNetworkException(
    method: error.request.method,
    url: error.request.uri.path,
    statusCode: error.response.statusCode,
    message: message,
  );
}
