import 'package:places/utils/coord.dart';

import 'location_repository.dart';

/// Иммитация получения координат.
class MockLocationRepository implements LocationRepository {
  Coord? _lastLocation;

  @override
  Coord? get lastLocation => _lastLocation;

  @override
  Future<Coord?> getLocation() async =>
      _lastLocation = const Coord(48.482406, 135.078146);
}
