import 'package:places/utils/coord.dart';

import 'location_repository.dart';

/// Получение координат (в будущем).
class RealLocationRepository implements LocationRepository {
  @override
  Coord get location => const Coord(48.479672, 135.070692);
  // Coord get location => const Coord(30.312733, 59.940073);
}