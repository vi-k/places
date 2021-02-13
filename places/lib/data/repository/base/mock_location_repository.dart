import 'package:places/utils/coord.dart';

import 'location_repository.dart';

class MockLocationRepository implements LocationRepository {
  @override
  Coord get location => const Coord(48.482406, 135.078146);
}