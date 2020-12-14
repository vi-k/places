import 'domain/sight.dart';

final List<Sight> mocks = [
  Sight(
    name: 'Краеведческий музей',
    lat: 48.473385,
    lon: 135.050809,
    url: 'https://hkm.ru/images/content/omuseum/sovremennoe-zdanie-muzeya.jpg',
    details: 'Хабаровский краевой музей имени Н.И. Гродекова',
    type: SightType.museum,
    visitTime: DateTime(2021, 1, 3),
  ),
  Sight(
    name: 'Театр музыкальной комедии',
    lat: 48.484179,
    lon: 135.077443,
    url: 'https://upload.wikimedia.org/wikipedia/ru/thumb/4/4c/%D0%A5%D0%B0%D0%B1%D0%B0%D1%80%D0%BE%D0%B2%D1%81%D0%BA%2C_%D0%BA%D1%80%D0%B0%D0%B5%D0%B2%D0%BE%D0%B9_%D0%BC%D1%83%D0%B7%D1%8B%D0%BA%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9_%D1%82%D0%B5%D0%B0%D1%82%D1%80_%D1%84%D0%BE%D1%82%D0%BE1.jpg/1920px-%D0%A5%D0%B0%D0%B1%D0%B0%D1%80%D0%BE%D0%B2%D1%81%D0%BA%2C_%D0%BA%D1%80%D0%B0%D0%B5%D0%B2%D0%BE%D0%B9_%D0%BC%D1%83%D0%B7%D1%8B%D0%BA%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D0%B9_%D1%82%D0%B5%D0%B0%D1%82%D1%80_%D1%84%D0%BE%D1%82%D0%BE1.jpg',
    details: 'Хабаровский краевой театр музыкальной комедии',
    type: SightType.theatre,
    visitTime: DateTime(2021, 1, 4),
  ),
  Sight(
    name: 'Памятник Я.В. Дьяченко',
    lat: 48.473917,
    lon: 135.051147,
    url: 'https://avatars.mds.yandex.net/get-altay/2369616/2a000001713b425bb87a0b94815093df70a5/XXXL',
    details: 'Дьяченко был командиром 13-го Сибирского батальона, солдаты которого образовала сторожевой пост, на Амуре, на месте которого теперь стоит город Хабаровск.',
    type: SightType.memorial,
  ),
  Sight(
    name: 'Парк Динамо',
    lat: 48.482406,
    lon: 135.078146,
    url: 'https://prokhv.ru/uploads/medialib/thumbnails/3c89c133-b200-436c-96d3-ccc31279254b_760x10000.png',
    details: 'Городской парк культуры и отдыха "Динамо" - большой красивый парк в центре Хабаровска. Площадь парка - 31 гектар.',
    type: SightType.park,
    visited: DateTime(2020, 12, 12),
  ),
];
