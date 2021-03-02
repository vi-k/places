class NetworkException implements Exception {
  NetworkException({
    required this.url,
    required this.statusCode,
    required this.message,
  });

  final String url;
  final int statusCode;
  final String message;

  @override
  String toString() =>
      "В запросе '$url' возникла ошибка: $message";
}
