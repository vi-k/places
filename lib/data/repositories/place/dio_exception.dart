import 'dart:convert';

import 'package:dio/dio.dart';

import 'repository_exception.dart';
import 'repository_network_exception.dart';

String _messageFromJson(Map<String, dynamic> json) =>
    json.containsKey('reasons')
        ? '${json['error']}: '
            '${(json['reasons'] as List<dynamic>).join(', ')}'
        : json['error'].toString();

RepositoryException createExceptionFromDio(DioError error) {
  final method = error.requestOptions.method;
  final url = error.requestOptions.uri.path;
  final statusCode = error.response?.statusCode ?? 0;
  var message = error.message.replaceFirst(
    RegExp(
      r'\s*\[' '$statusCode' r'\]$',
    ),
    '',
  );
  String? data;

  if (error.type == DioErrorType.response) {
    final dynamic responseData = error.response?.data;
    if (responseData != null && responseData is String) {
      if (responseData.isEmpty) message = 'no description';

      try {
        message =
            _messageFromJson(jsonDecode(responseData) as Map<String, dynamic>);
      } on FormatException catch (_) {
        data = responseData;
      }
    }
  }

  return RepositoryNetworkException(
    method: method,
    url: url,
    statusCode: statusCode,
    message: message,
    data: data,
  );
}
