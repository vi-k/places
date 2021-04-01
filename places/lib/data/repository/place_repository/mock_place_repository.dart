import 'package:places/data/model/filter.dart';
import 'package:places/data/model/place_base.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/repository/place_repository/place_repository.dart';
import 'package:places/data/repository/place_repository/repository_exception.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/let_and_also.dart';
import 'package:places/utils/sort.dart';

/// Моковый репозиторий мест.
class MockPlaceRepository extends PlaceRepository {
  MockPlaceRepository() {
    _places = [
      PlaceBase(
        id: _nextId++,
        name: 'Краеведческий музей',
        coord: const Coord(48.473385, 135.050809),
        photos: const [
          'https://hkm.ru/images/content/omuseum/sovremennoe-zdanie-muzeya.jpg',
        ],
        description: 'Хабаровский краевой музей имени Н.И. Гродекова',
        type: PlaceType.museum,
      ),
      PlaceBase(
        id: _nextId++,
        name: 'Пани Фазани',
        coord: const Coord(48.473156, 135.058130),
        photos: const [
          'https://10619-2.s.cdn12.com/r8/Pani-Fazani-bar-counter.jpg',
        ],
        description: 'Чешская и европейская кухня. Фермерская пивоварня',
        type: PlaceType.restaurant,
      ),
      PlaceBase(
        id: _nextId++,
        name: 'Интурист',
        coord: const Coord(48.474615, 135.051497),
        photos: const [
          'https://pro-oteli.ru/upload/iblock/a08/a088d3e2c71c2d5c96403f4c48bcccc5.jpg',
        ],
        description:
            'Гостиница «Интурист» расположена в историческом центре Хабаровска, в парке, в двух шагах от набережной реки Амур. Рядом с гостиницей находится деловая часть города: краеведческий, художественный и военный музеи, театры, концертные залы филармонии и дома офицеров Российской Армии, а также магазины, рестораны и банки.',
        type: PlaceType.hotel,
      ),
      PlaceBase(
        id: _nextId++,
        name: 'Дуэт',
        coord: const Coord(48.472000, 135.057208),
        photos: const [
          'https://cdn1.flamp.ru/535fa22fe89271aeafa4778c6f7d6933_600_600.jpg',
        ],
        description: 'Кафе-кондитерская.',
        type: PlaceType.cafe,
      ),
      PlaceBase(
        id: _nextId++,
        name: 'Памятник Я.В. Дьяченко',
        coord: const Coord(48.473917, 135.051147),
        photos: const [
          'https://avatars.mds.yandex.net/get-altay/2369616/2a000001713b425bb87a0b94815093df70a5/XXXL',
        ],
        description:
            'Дьяченко был командиром 13-го Сибирского батальона, солдаты которого образовала сторожевой пост, на Амуре, на месте которого теперь стоит город Хабаровск.',
        type: PlaceType.other,
      ),
      PlaceBase(
        id: _nextId++,
        name: 'Парк Динамо',
        coord: const Coord(48.482406, 135.078146),
        photos: const [
          'https://prokhv.ru/uploads/medialib/thumbnails/3c89c133-b200-436c-96d3-ccc31279254b_760x10000.png',
        ],
        description:
            'Городской парк культуры и отдыха "Динамо" - большой красивый парк в центре Хабаровска. Площадь парка - 31 гектар.',
        type: PlaceType.park,
      ),
      PlaceBase(
        id: _nextId++,
        name: 'Музей Амурского моста',
        coord: const Coord(48.540781, 135.013038),
        photos: const [
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Museum_of_amur_bridge.jpg/1920px-Museum_of_amur_bridge.jpg',
        ],
        description:
            'Музей истории Амурского моста — посвящён строительству и реконструкции моста через реку Амур у города Хабаровска, дополнительно под открытым небом выставлена железнодорожная техника и главный экспонат музея — демонтированная в ходе реконструкции ферма «царского» моста.',
        type: PlaceType.museum,
      ),
    ];
  }

  var _nextId = 31;
  late final List<PlaceBase> _places;

  int _index(int id) => _places.indexWhere((e) => e.id == id);

  /// Создаёт новое временное место.
  @override
  Future<int> create(PlaceBase place) async {
    final id = place.id != 0 ? place.id : _nextId++;

    final index = _index(id);
    if (index != -1) throw RepositoryAlreadyExistsException();

    _places.add(place.copyWith(id: id));
    return id;
  }

  /// Загружает информацию о месте.
  @override
  Future<PlaceBase> read(int id) async {
    final index = _index(id);
    if (index == -1) throw RepositoryNotFoundException();

    return _places[index];
  }

  /// Обновляет информацию о месте.
  @override
  Future<void> update(PlaceBase place) async {
    final index = _index(place.id);
    if (index == -1) throw RepositoryNotFoundException();

    _places[index] = place;
  }

  /// Удаляет место.
  @override
  Future<void> delete(int id) async {
    final index = _index(id);
    if (index == -1) throw RepositoryNotFoundException();

    _places.removeAt(index);
  }

  /// Имитирует загрузку списка мест.
  @override
  Future<List<PlaceBase>> loadList(
      {int? count,
      int? offset,
      PlaceOrderBy? pageBy,
      Object? pageLastValue,
      Map<PlaceOrderBy, Object>? orderBy}) async {
    // Сначала сортируем.
    final list = [..._places];
    if (orderBy != null) {
      list.sort((a, b) {
        for (final sort in orderBy.entries) {
          if (sort.key == PlaceOrderBy.id) {
            final res = sort.value == Sort.asc ? a.id - b.id : b.id - a.id;
            if (res != 0) return res;
          } else if (sort.key == PlaceOrderBy.name) {
            final res = sort.value == Sort.asc
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name);
            if (res != 0) return res;
          }
        }
        return 0;
      });
    }

    Iterable<PlaceBase> result = list;

    // Последовательно загружаем (fetch) страниц через [pageBy].
    if (pageBy != null) {
      // Должна быть указана сортировка по заданному полю [pageBy].
      if (orderBy == null) {
        throw RepositoryException('the [orderBy] is expected');
      }

      final sort = orderBy[pageBy];
      if (sort == null) {
        throw RepositoryException(
            'the [orderBy] must contain the field of the [pageBy]');
      }

      // Должно быть указано последнее значение заданного поля.
      if (pageLastValue == null) {
        throw RepositoryException('the [pageLastValue] is expected');
      }

      // Пропускаем уже загруженные данные с учётом того, в какую сторону
      // происходит сортировка.
      if (pageBy == PlaceOrderBy.id) {
        pageLastValue as int;
        result = result.skipWhile(sort == Sort.asc
            ? (value) => value.id <= pageLastValue
            : (value) => value.id >= pageLastValue);
      } else if (pageBy == PlaceOrderBy.name) {
        pageLastValue as String;
        result = result.skipWhile(sort == Sort.asc
            ? (value) => value.name.compareTo(pageLastValue) <= 0
            : (value) => value.name.compareTo(pageLastValue) >= 0);
      }
    }

    if (offset != null) result = result.skip(offset);
    if (count != null) result = result.take(count);
    return result.toList();
  }

  /// Имитирует загрузку списка мест, соответствующих фильтру.
  @override
  Future<List<PlaceBase>> loadFilteredList(
      {Coord? coord, required Filter filter}) async {
    Iterable<PlaceBase> tmp = _places;

    filter.placeTypes?.let((it) {
      tmp = tmp.where((e) => it.contains(e.type));
    });

    // Расчёт расстояния, если задана точка отсчёта, и фильтрация по расстоянию.
    if (coord != null) {
      tmp = tmp
          .map((e) => e.copyWith(calcDistanceFrom: coord))
          .where((e) => (e.distance ?? Distance.zero) <= filter.radius);
    }

    final result = tmp.toList();

    // Сортировка по расстоянию.
    if (coord != null) result.sort();

    return result;
  }

  /// Имитирует поиск по названию.
  @override
  Future<List<PlaceBase>> search({Coord? coord, required String text}) async {
    Iterable<PlaceBase> tmp = _places;

    final lowerCaseText = text.toLowerCase();
    tmp = tmp.where((e) => e.name.toLowerCase().contains(lowerCaseText));

    // Расчёт расстояния, если задана точка отсчёта.
    if (coord != null) {
      tmp = tmp.map((e) => e.copyWith(calcDistanceFrom: coord));
    }

    final result = tmp.toList();

    // Сортировка по расстоянию.
    if (coord != null) result.sort();

    return result;
  }
}
