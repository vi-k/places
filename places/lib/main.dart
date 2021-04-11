import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'bloc_observer.dart';
import 'logger.dart';

void main() {
  // await moveFromMockToRepository();

  Bloc.observer = MyBlocObserver(logger);

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
