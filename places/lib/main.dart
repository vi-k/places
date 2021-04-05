import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'bloc_observer.dart';

Future<void> main() async {
  // await moveFromMockToRepository();

  Bloc.observer = MyBlocObserver();

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
