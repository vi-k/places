import 'repository_exception.dart';

class RepositoryNetworkException extends RepositoryException {
  RepositoryNetworkException({
    required this.method,
    required this.url,
    required this.statusCode,
    required String message,
  })   : networkMessage = message,
        super(message);

  final String method;
  final String url;
  final int statusCode;
  final String networkMessage;

  @override
  String get message {
    final msg = networkMessage.replaceFirst(
        RegExp(
          r'\s*\[' '$statusCode' r'\]$',
        ),
        '');
    return 'В запросе $method $url возникла ошибка: $msg';
  }
}
