import 'dart:math';

import 'package:flutter/material.dart';

import '../ui/res/svg.dart';
import '../utils/maps.dart';
import 'category.dart';
import 'sight.dart';

/// Моковые координаты.
const myMockCoord = Coord(48.479672, 135.070692);

/// Моковые данные.
// ignore: prefer_mixin
class MocksData extends ChangeNotifier {
  MocksData() {
    _categories = [
      Category(
        id: _categoriesNextId++,
        name: 'Кафе',
        svg: Svg32.cafe,
      ),
      Category(
        id: _categoriesNextId++,
        name: 'Гостиница',
        svg: Svg32.hotel,
      ),
      Category(
        id: _categoriesNextId++,
        name: 'Музей',
        svg: Svg32.museum,
      ),
      Category(
        id: _categoriesNextId++,
        name: 'Ресторан',
        svg: Svg32.restaurant,
      ),
      Category(
        id: _categoriesNextId++,
        name: 'Парк',
        svg: Svg32.park,
      ),
      Category(
        id: _categoriesNextId++,
        name: 'Особое место',
        svg: Svg32.particularPlace,
      ),
    ];

    _sights = [
      Sight(
        id: _sightsNextId++,
        name: 'Краеведческий музей',
        coord: const Coord(48.473385, 135.050809),
        photos: const [
          'https://hkm.ru/images/content/omuseum/sovremennoe-zdanie-muzeya.jpg',
        ],
        details: 'Хабаровский краевой музей имени Н.И. Гродекова',
        categoryId: 3,
        visited: true,
        visitedTime: DateTime(2021, 1, 3),
      ),
      Sight(
        id: _sightsNextId++,
        name: 'Пани Фазани',
        coord: const Coord(48.473156, 135.058130),
        photos: const [
          'https://10619-2.s.cdn12.com/r8/Pani-Fazani-bar-counter.jpg',
        ],
        details: 'Чешская и европейская кухня. Фермерская пивоварня',
        categoryId: 4,
        visitTime: DateTime(2021, 1, 4),
      ),
      Sight(
        id: _sightsNextId++,
        name: 'Интурист',
        coord: const Coord(48.474615, 135.051497),
        photos: const [
          'https://pro-oteli.ru/upload/iblock/a08/a088d3e2c71c2d5c96403f4c48bcccc5.jpg',
        ],
        details:
            'Гостиница «Интурист» расположена в историческом центре Хабаровска, в парке, в двух шагах от набережной реки Амур. Рядом с гостиницей находится деловая часть города: краеведческий, художественный и военный музеи, театры, концертные залы филармонии и дома офицеров Российской Армии, а также магазины, рестораны и банки.',
        categoryId: 2,
        visitTime: DateTime(2021, 1, 4),
      ),
      Sight(
        id: _sightsNextId++,
        name: 'Дуэт',
        coord: const Coord(48.472000, 135.057208),
        photos: const [
          'https://cdn1.flamp.ru/535fa22fe89271aeafa4778c6f7d6933_600_600.jpg',
        ],
        details: 'Кафе-кондитерская.',
        categoryId: 1,
        visitTime: DateTime(2020, 12, 20),
      ),
      Sight(
        id: _sightsNextId++,
        name: 'Памятник Я.В. Дьяченко',
        coord: const Coord(48.473917, 135.051147),
        photos: const [
          'https://avatars.mds.yandex.net/get-altay/2369616/2a000001713b425bb87a0b94815093df70a5/XXXL',
        ],
        details:
            'Дьяченко был командиром 13-го Сибирского батальона, солдаты которого образовала сторожевой пост, на Амуре, на месте которого теперь стоит город Хабаровск.',
        categoryId: 6,
      ),
      Sight(
        id: _sightsNextId++,
        name: 'Парк Динамо',
        coord: const Coord(48.482406, 135.078146),
        photos: const [
          'https://prokhv.ru/uploads/medialib/thumbnails/3c89c133-b200-436c-96d3-ccc31279254b_760x10000.png',
        ],
        details:
            'Городской парк культуры и отдыха "Динамо" - большой красивый парк в центре Хабаровска. Площадь парка - 31 гектар.',
        categoryId: 5,
        visited: true,
        visitedTime: DateTime(2020, 12, 12),
      ),
      Sight(
        id: _sightsNextId++,
        name: 'Музей Амурского моста',
        coord: const Coord(48.540781, 135.013038),
        photos: const [
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Museum_of_amur_bridge.jpg/1920px-Museum_of_amur_bridge.jpg',
        ],
        details:
            'Музей истории Амурского моста — посвящён строительству и реконструкции моста через реку Амур у города Хабаровска, дополнительно под открытым небом выставлена железнодорожная техника и главный экспонат музея — демонтированная в ходе реконструкции ферма «царского» моста.',
        categoryId: 3,
      ),
    ];

    _favoriteSet = <int>{2, 3, 4};
  }

  /// Категории.
  var _categoriesNextId = 1;
  late final List<Category> _categories;
  int _categoryIndex(int id) => _categories.indexWhere((e) => e.id == id);
  Future<List<Category>> get categories async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (Random().nextBool()) {
      return Future.error('Network failed');
    }
    return _categories;
  }

  Category categoryById(int id) => _categories[_categoryIndex(id)];
  Future<Category> categoryById2(int id) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (Random().nextBool()) {
      return Future.error('Network failed');
    }
    return _categories[_categoryIndex(id)];
  }

  /// Достопримечательности.
  var _sightsNextId = 1;
  late final List<Sight> _sights;
  int _sightIndex(int id) => _sights.indexWhere((e) => e.id == id);

  List<Sight> get sights => _sights;
  Sight sightById(int id) => _sights[_sightIndex(id)];
  Future<Sight> sightById2(int id) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (Random().nextBool()) {
      return Future.error('Network failed');
    }
    return _sights[_sightIndex(id)];
  }

  /// Избранное.
  late Set<int> _favoriteSet;
  Iterable<Sight> get favorites => _favoriteSet.map<Sight>(sightById);
  Iterable<Sight> get visited => _sights.where((e) => e.visited);

  // late Filter? _filter;
  // Future<Filter> get filter async {
  // }

  @override
  String toString() => 'MocksData(length: ${_sights.length})';

  int addSight(Sight sight) {
    final id = _sightsNextId++;
    _sights.add(sight.copyWith(id: id));
    notifyListeners();
    return id;
  }

  void replaceSight(int id, Sight sight) {
    _sights[_sightIndex(id)] = sight;
    notifyListeners();
  }

  void removeSight(int id) {
    _sights.removeAt(_sightIndex(id));
    notifyListeners();
  }

  bool isFavorite(int id) => _favoriteSet.contains(id);

  void addToFavorite(int id) {
    _favoriteSet.add(id);
    notifyListeners();
  }

  void removeFromFavorite(int id) {
    _favoriteSet.remove(id);
    notifyListeners();
  }

  void toggleFavorite(int id) {
    isFavorite(id) ? removeFromFavorite(id) : addToFavorite(id);
  }

  void moveFavorite(int from, int to) {
    final id = _favoriteSet.elementAt(from);
    _favoriteSet.remove(id);
    final newPos = to > from ? to - 1 : to;
    _favoriteSet = {
      ..._favoriteSet.take(newPos),
      id,
      ..._favoriteSet.skip(newPos),
    };
    notifyListeners();
  }

  void addToVisited(int id) {
    final sight = sightById(id).copyWith(visited: true);
    replaceSight(id, sight);
    notifyListeners();
  }

  void removeFromVisited(int id) {
    final sight = sightById(id).copyWith(visited: false);
    replaceSight(id, sight);
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
