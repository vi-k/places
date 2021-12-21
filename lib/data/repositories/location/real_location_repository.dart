import 'package:geolocator/geolocator.dart';
import 'package:places/utils/coord.dart';

import 'location_repository.dart';

/// Получение координат (в будущем).
class RealLocationRepository implements LocationRepository {
  Coord? _lastLocation;

  @override
  Coord? get lastLocation => _lastLocation;

  Future<Position?> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) return null;
    }

    return Geolocator.getCurrentPosition();
  }

  @override
  Future<Coord?> getLocation() async {
    final pos = await getCurrentPosition();

    return _lastLocation =
        pos == null ? null : Coord(pos.latitude, pos.longitude);
  }
}
