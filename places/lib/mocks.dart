import 'dart:collection';

import 'package:flutter/material.dart';

import 'domain/sight.dart';
import 'utils/maps.dart';

/// Моковые координаты.
const myMockCoord = Coord(48.479672, 135.070692);

/// Моковые данные.
// ignore: prefer_mixin
class Mocks extends IterableBase<Sight> with ChangeNotifier {
  Mocks() {
    _mocks = [
      Sight(
        id: _mockId++,
        name: 'Краеведческий музей',
        coord: const Coord(48.473385, 135.050809),
        photos: const [
          'https://hkm.ru/images/content/omuseum/sovremennoe-zdanie-muzeya.jpg',
        ],
        details: 'Хабаровский краевой музей имени Н.И. Гродекова',
        category: SightCategory.museum,
        state: SightState.favorite,
        visitTime: DateTime(2021, 1, 3),
      ),
      Sight(
        id: _mockId++,
        name: 'Пани Фазани',
        coord: const Coord(48.473156, 135.058130),
        photos: const [
          'https://10619-2.s.cdn12.com/r8/Pani-Fazani-bar-counter.jpg',
        ],
        details: 'Чешская и европейская кухня. Фермерская пивоварня',
        category: SightCategory.restaurant,
        state: SightState.favorite,
        visitTime: DateTime(2021, 1, 4),
      ),
      Sight(
        id: _mockId++,
        name: 'Интурист',
        coord: const Coord(48.474615, 135.051497),
        photos: const [
          'https://pro-oteli.ru/upload/iblock/a08/a088d3e2c71c2d5c96403f4c48bcccc5.jpg',
        ],
        details:
            'Гостиница «Интурист» расположена в историческом центре Хабаровска, в парке, в двух шагах от набережной реки Амур. Рядом с гостиницей находится деловая часть города: краеведческий, художественный и военный музеи, театры, концертные залы филармонии и дома офицеров Российской Армии, а также магазины, рестораны и банки.',
        category: SightCategory.hotel,
        state: SightState.favorite,
        visitTime: DateTime(2021, 1, 4),
      ),
      Sight(
        id: _mockId++,
        name: 'Дуэт',
        coord: const Coord(48.472000, 135.057208),
        photos: const [
          'https://cdn1.flamp.ru/535fa22fe89271aeafa4778c6f7d6933_600_600.jpg',
        ],
        details: 'Кафе-кондитерская.',
        category: SightCategory.cafe,
        state: SightState.visited,
        visited: DateTime(2020, 12, 20),
      ),
      Sight(
        id: _mockId++,
        name: 'Памятник Я.В. Дьяченко',
        coord: const Coord(48.473917, 135.051147),
        photos: const [
          'https://avatars.mds.yandex.net/get-altay/2369616/2a000001713b425bb87a0b94815093df70a5/XXXL',
        ],
        details:
            'Дьяченко был командиром 13-го Сибирского батальона, солдаты которого образовала сторожевой пост, на Амуре, на месте которого теперь стоит город Хабаровск.',
        category: SightCategory.particular,
      ),
      Sight(
        id: _mockId++,
        name: 'Парк Динамо',
        coord: const Coord(48.482406, 135.078146),
        photos: const [
          'https://prokhv.ru/uploads/medialib/thumbnails/3c89c133-b200-436c-96d3-ccc31279254b_760x10000.png',
        ],
        details:
            'Городской парк культуры и отдыха "Динамо" - большой красивый парк в центре Хабаровска. Площадь парка - 31 гектар.',
        category: SightCategory.park,
        state: SightState.visited,
        visited: DateTime(2020, 12, 12),
      ),
      Sight(
        id: _mockId++,
        name: 'Музей Амурского моста',
        coord: const Coord(48.540781, 135.013038),
        photos: const [
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Museum_of_amur_bridge.jpg/1920px-Museum_of_amur_bridge.jpg',
        ],
        details:
            'Музей истории Амурского моста — посвящён строительству и реконструкции моста через реку Амур у города Хабаровска, дополнительно под открытым небом выставлена железнодорожная техника и главный экспонат музея — демонтированная в ходе реконструкции ферма «царского» моста.',
        category: SightCategory.museum,
      ),
    ];
  }

  var _mockId = 0;
  late final List<Sight> _mocks;

  @override
  Iterator<Sight> get iterator => _mocks.iterator;

  Sight operator [](int id) {
    final index = _mocks.indexWhere((element) => element.id == id);
    return _mocks[index];
  }

  int add(Sight sight) {
    final id = _mockId++;
    _mocks.add(sight.copyWith(id: id));
    notifyListeners();
    return id;
  }

  void replace(int id, Sight sight) {
    final index = _mocks.indexWhere((element) => element.id == id);
    _mocks[index] = sight;
    notifyListeners();
  }

  void remove(int id) {
    final index = _mocks.indexWhere((element) => element.id == id);
    _mocks.removeAt(index);
    notifyListeners();
  }
}

/// Моковые фотографии.
const mockPhotos = [
  'https://top10.travel/wp-content/uploads/2014/12/hram-vasiliya-blazhennogo.jpg',
  'https://img.gazeta.ru/files3/957/10301957/00-pic905-895x505-58873.jpg',
  'https://way2day.com/wp-content/uploads/2018/06/Dostoprimechatelnosti-Turtsii.jpg',
  'https://uploads.europa24.ru/rs/580w/news/2017-08/berlinskiy-dom-59819f21c5469.jpg',
  'https://top10.travel/wp-content/uploads/2014/09/brandenburgskie-vorota-1.jpg',
  'https://vibirai.ru/image/1155920.w640.jpg',
  'https://kor.ill.in.ua/m/610x385/2445355.jpg',
  'https://www.topkurortov.com/wp-content/uploads/2015/12/pizanskaya-bashnia.jpg',
  'https://tripplanet.ru/wp-content/uploads/europe/england/london/london-dostoprimechatelnosti.jpg',
  'https://crimeaguide.com/wp-content/uploads/2016/05/last.jpg',
];
