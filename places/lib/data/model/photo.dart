import 'package:equatable/equatable.dart';

/// Информация
class Photo extends Equatable {
  const Photo({
    this.url,
    this.path,
  })  : assert(url != null && path == null || url == null && path != null);

  final String? url;
  final String? path;

  bool get isLoaded => url != null;

  @override
  List<Object?> get props => [url, path];

  @override
  String toString() => 'Photo(url: $url, path: $path)';
}
