import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';

class RepositoryException implements Exception {
  RepositoryException(this.message);

  RepositoryException.fromJson(Map<String, dynamic> json)
      : message = json.containsKey('reasons')
            ? '${json['error']}: '
                '${(json['reasons'] as List<dynamic>).join(', ')}'
            : json['error'].toString();
  final String message;

  static RepositoryException? fromDio(DioError error) {
    if (error.type != DioErrorType.RESPONSE) return null;

    final dynamic data = error.response?.data;
    if (data != null && data is String) {
      if (data.isEmpty) return RepositoryException('no description');

      try {
        return RepositoryException.fromJson(
            jsonDecode(data) as Map<String, dynamic>);
      } on FormatException catch (_) {
        return RepositoryException('unknown error: "$data"');
      }
    }
    return null;
  }

  @override
  String toString() => 'RepositoryException($message)';
}

class RepositoryNotFoundException extends RepositoryException {
  RepositoryNotFoundException() : super('object not found');
}

class RepositoryAlreadyExistsException extends RepositoryException {
  RepositoryAlreadyExistsException() : super('object already exists');
}
