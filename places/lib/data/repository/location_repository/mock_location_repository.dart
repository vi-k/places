import 'package:places/utils/coord.dart';

import 'location_repository.dart';

/// Иммитация получения координат.
class MockLocationRepository implements LocationRepository {
  @override
  Future<Coord?> getLocation() async => const Coord(48.482406, 135.078146);
}
