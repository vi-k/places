import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app.dart';

Future<void> main() async {
  // await moveFromMockToRepository();

  Intl.defaultLocale = 'ru_RU';

  runApp(App());
}

// // Перенос мест из моковых в БД
// Future<void> moveFromMockToRepository() async {
//   final placeRepository = ApiPlaceRepository(dio, ApiPlaceMapper());
//   final mocksRepository = MockPlaceRepository();
//   final mocksList = await mocksRepository.loadList();
//   for (final place in mocksList) {
//     try {
//       await placeRepository.create(place);
//     } on RepositoryAlreadyExistsException {
//       await placeRepository.update(place);
//     }
//   }
// }
