import 'package:places/data/model/place_type.dart';
import 'package:places/ui/res/svg.dart';

class PlaceTypeUi {
  PlaceTypeUi(this.placeType)
      : name = _toName[placeType.value]!,
        svg = _toSvg[placeType.value]!;

  final PlaceType placeType;
  final String name;
  final String svg;

  String get id => placeType.id;
  String get lowerCaseName => name.toLowerCase();

  static const _toName = {
    PlaceTypeEnum.cafe: 'Кафе',
    PlaceTypeEnum.hotel: 'Гостиница',
    PlaceTypeEnum.museum: 'Музей',
    PlaceTypeEnum.park: 'Парк',
    PlaceTypeEnum.other: 'Особое место',
    PlaceTypeEnum.restaurant: 'Ресторан',
  };

  static const _toSvg = {
    PlaceTypeEnum.cafe: Svg32.cafe,
    PlaceTypeEnum.hotel: Svg32.hotel,
    PlaceTypeEnum.museum: Svg32.museum,
    PlaceTypeEnum.park: Svg32.park,
    PlaceTypeEnum.restaurant: Svg32.restaurant,
    PlaceTypeEnum.other: Svg32.other,
  };
}
