import 'package:places/utils/coord.dart';

/// Интерфейс получения координат.
// ignore: one_member_abstracts
abstract class LocationRepository {
  Future<Coord?> getLocation();
}