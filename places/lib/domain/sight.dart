import '../translate.dart';

enum SightType {
  museum,
  theatre,
  memorial,
  park,
}

class Sight {
  final String name;
  final double lat;
  final double lon;
  final String url;
  final String details;
  final SightType type;
  final DateTime? visitTime;
  final DateTime? visited;

  Sight({
    required this.name,
    required this.lat,
    required this.lon,
    required this.url,
    required this.details,
    required this.type,
    this.visitTime,
    this.visited,
  });

  String get typeAsText => translate(type.toString());
}
