import 'package:places/utils/coord.dart';

/// Интерфейс получения координат.
abstract class LocationRepository {
  Coord get location;
}