class RepositoryException implements Exception {
  RepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RepositoryNotFoundException extends RepositoryException {
  RepositoryNotFoundException() : super('object not found');
}

class RepositoryAlreadyExistsException extends RepositoryException {
  RepositoryAlreadyExistsException() : super('object already exists');
}
