import 'package:places/data/model/place_type.dart';
import 'package:places/ui/res/svg.dart';

class PlaceTypeUi {
  PlaceTypeUi(this.type)
      : name = _toName[type]!,
        svg = _toSvg[type]!;

  final PlaceType type;
  final String name;
  final String svg;

  String get id => type.name;
  String get lowerCaseName => name.toLowerCase();

  static const _toName = {
    PlaceType.cafe: 'Кафе',
    PlaceType.hotel: 'Гостиница',
    PlaceType.museum: 'Музей',
    PlaceType.park: 'Парк',
    PlaceType.other: 'Особое место',
    PlaceType.restaurant: 'Ресторан',
  };

  static const _toSvg = {
    PlaceType.cafe: Svg32.cafe,
    PlaceType.hotel: Svg32.hotel,
    PlaceType.museum: Svg32.museum,
    PlaceType.park: Svg32.park,
    PlaceType.restaurant: Svg32.restaurant,
    PlaceType.other: Svg32.other,
  };
}
