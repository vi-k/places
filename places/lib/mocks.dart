import 'domain/sight.dart';
import 'utils/maps.dart';

const myMockCoord = Coord(48.479672, 135.070692);

final List<Sight> mocks = [
  Sight(
    name: 'Краеведческий музей',
    coord: const Coord(48.473385, 135.050809),
    url: 'https://hkm.ru/images/content/omuseum/sovremennoe-zdanie-muzeya.jpg',
    details: 'Хабаровский краевой музей имени Н.И. Гродекова',
    type: SightType.museum,
    visitTime: DateTime(2021, 1, 3),
  ),
  Sight(
    name: 'Пани Фазани',
    coord: const Coord(48.473156, 135.058130),
    url: 'https://10619-2.s.cdn12.com/r8/Pani-Fazani-bar-counter.jpg',
    details: 'Чешская и европейская кухня. Фермерская пивоварня',
    type: SightType.restaurant,
    visitTime: DateTime(2021, 1, 4),
  ),
  Sight(
    name: 'Интурист',
    coord: const Coord(48.474615, 135.051497),
    url: 'https://pro-oteli.ru/upload/iblock/a08/a088d3e2c71c2d5c96403f4c48bcccc5.jpg',
    details: 'Гостиница «Интурист» расположена в историческом центре Хабаровска, в парке, в двух шагах от набережной реки Амур. Рядом с гостиницей находится деловая часть города: краеведческий, художественный и военный музеи, театры, концертные залы филармонии и дома офицеров Российской Армии, а также магазины, рестораны и банки.',
    type: SightType.hotel,
    visitTime: DateTime(2021, 1, 4),
  ),
  Sight(
    name: 'Дуэт',
    coord: const Coord(48.472000, 135.057208),
    url: 'https://cdn1.flamp.ru/535fa22fe89271aeafa4778c6f7d6933_600_600.jpg',
    details: 'Кафе-кондитерская.',
    type: SightType.cafe,
    visited: DateTime(2020, 12, 20),
  ),
  Sight(
    name: 'Памятник Я.В. Дьяченко',
    coord: const Coord(48.473917, 135.051147),
    url: 'https://avatars.mds.yandex.net/get-altay/2369616/2a000001713b425bb87a0b94815093df70a5/XXXL',
    details: 'Дьяченко был командиром 13-го Сибирского батальона, солдаты которого образовала сторожевой пост, на Амуре, на месте которого теперь стоит город Хабаровск.',
    type: SightType.particular,
  ),
  Sight(
    name: 'Парк Динамо',
    coord: const Coord(48.482406, 135.078146),
    url: 'https://prokhv.ru/uploads/medialib/thumbnails/3c89c133-b200-436c-96d3-ccc31279254b_760x10000.png',
    details: 'Городской парк культуры и отдыха "Динамо" - большой красивый парк в центре Хабаровска. Площадь парка - 31 гектар.',
    type: SightType.park,
    visited: DateTime(2020, 12, 12),
  ),
  Sight(
    name: 'Музей Амурского моста',
    coord: const Coord(48.540781, 135.013038),
    url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Museum_of_amur_bridge.jpg/1920px-Museum_of_amur_bridge.jpg',
    details: 'Музей истории Амурского моста — посвящён строительству и реконструкции моста через реку Амур у города Хабаровска, дополнительно под открытым небом выставлена железнодорожная техника и главный экспонат музея — демонтированная в ходе реконструкции ферма «царского» моста.',
    type: SightType.museum,
  ),
];
