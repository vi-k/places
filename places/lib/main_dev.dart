import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'bloc_observer.dart';
import 'environment/build_config.dart';
import 'environment/build_type.dart';
import 'environment/environment.dart';

void main() {
  Environment.init(
    buildType: BuildType.dev,
    buildConfig: const BuildConfig(message: "It's a dev flavor"),
    loggerLevel: Level.verbose,
  );

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
