// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:places/data/repository/api_place_mapper.dart';
import 'package:places/utils/distance.dart';

import 'app.dart';
import 'data/interactor/place_interactor.dart';
import 'data/interactor/settings_interactor.dart';
import 'data/model/place_base.dart';
import 'data/model/place_type.dart';
import 'data/repository/api_place_repository.dart';
import 'data/repository/base/filter.dart';
import 'data/repository/base/location_repository.dart';
import 'data/repository/base/mock_location_repository.dart';
import 'data/repository/base/place_repository.dart';
import 'data/repository/mock_place_repository.dart';
import 'data/repository/real_location_repository.dart';
import 'data/repository/repository_exception.dart';
import 'utils/coord.dart';
import 'utils/sort.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://test-backend-flutter.surfstudio.ru',
  connectTimeout: 5000,
  receiveTimeout: 5000,
  sendTimeout: 5000,
  responseType: ResponseType.json,
))
  ..interceptors.add(InterceptorsWrapper(
    onError: (error) {
      var message =
          'Ошибка при выполнении запроса ${error.request.method} ${error.request.uri}: '
          '${error.message} (${error.type})';
      final repositoryException = RepositoryException.fromDio(error);
      if (repositoryException != null) {
        message += ': ${repositoryException.message}';
      }
      print(message);
    },
    onRequest: (options) {
      print('Выполняется запрос: ${options.method} ${options.uri}');
      if (options.data != null) {
        print('data: ${options.data}');
      }
    },
    onResponse: (response) {
      print(
          'Получен ответ: ${response.statusMessage} (${response.statusCode})');
      // print(response.data);
    },
  ));

// Репозитории, интеракторы, фильтр (пока храним здесь)
final PlaceRepository placeRepository =
    ApiPlaceRepository(dio, ApiPlaceMapper());
final LocationRepository locationRepository = RealLocationRepository();
// final PlaceRepository placeRepository = MockPlaceRepository();
// final LocationRepository locationRepository = MockLocationRepository();
final placeInteractor = PlaceInteractor(
    placeRepository: placeRepository, locationRepository: locationRepository);
final settingsInteractor = SettingsInteractor();
Filter filter = Filter();

Future<void> main() async {
  // await moveFromMockToRepository();
  // await testPlaceRepository();

  await initializeDateFormatting('ru_RU', null);
  Intl.defaultLocale = 'ru_RU';

  runApp(App());
}

// Перенос мест из моковых в БД
Future<void> moveFromMockToRepository() async {
  if (placeRepository is! MockPlaceRepository) {
    final mocksRepository = MockPlaceRepository();
    final mocksList = await mocksRepository.loadList();
    for (final place in mocksList) {
      try {
        await placeRepository.create(place);
      } on RepositoryAlreadyExistsException {
        await placeRepository.update(place);
      }
    }
  }
}

Future<void> testPlaceRepository() async {
  void printPlaces(List<PlaceBase> places) {
    for (final place in places) {
      print(place.toString(short: true));
      // print(place.toString());
    }
  }

  // Весь список
  var list = await placeRepository.loadList();
  printPlaces(list);

  // Список постранично
  list = await placeRepository.loadList(
      count: 8,
      pageBy: PlaceOrderBy.name,
      pageLastValue: 'название',
      orderBy: {PlaceOrderBy.name: Sort.asc, PlaceOrderBy.id: Sort.asc});
  printPlaces(list);

  // Создание места
  final newPlaceId = await placeRepository.create(PlaceBase(
    coord: const Coord(0, 0),
    name: 'название',
    type: PlaceType.other,
    photos: ['фотография 1', 'фотография 2'],
    description: 'описание',
  ));
  print('new place id: $newPlaceId');

  list = await placeRepository.loadList();
  printPlaces(list);

  // Чтение места
  var place = await placeRepository.read(newPlaceId);
  print(place);

  // Обновление места
  place = place.copyWith(
    name: 'название 2',
    photos: [...place.photos, 'фотография 3'],
    description: 'описание 2',
  );

  await placeRepository.update(place);

  list = await placeRepository.loadList();
  printPlaces(list);

  // Удаление места
  await placeRepository.delete(place.id);

  list = await placeRepository.loadList();
  printPlaces(list);

  // Фильтр
  list = await placeInteractor.getPlaces(
    Filter(
      radius: const Distance.km(100),
      // typeFilter: {PlaceType.museum},
      // nameFilter: 'кра',
    ),
  );
  printPlaces(list);
}
