import 'dart:collection';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/repository/base/location_repository.dart';
import 'package:places/error_handler.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/utils/coord.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:relation/relation.dart';

import 'place_edit_screen.dart';

/// WidgetModel для PlaceEditScreen
class PlaceEditWm extends WidgetModel {
  PlaceEditWm._(
    WidgetModelDependencies baseDependencies,
    this.placeInteractor,
    this.locationRepository,
    Place? place,
  )   : placeState = EntityStreamedState<Place>(EntityState.content(place)),
        placeTypeState = EntityStreamedState<PlaceTypeUi>(EntityState.content(
            place == null ? null : PlaceTypeUi(place.type))),
        photosState = EntityStreamedState<UnmodifiableListView<String>>(
            EntityState.content(
                UnmodifiableListView(place == null ? [] : place.photos))),
        super(baseDependencies);

  // ignore: prefer_constructors_over_static_methods
  static PlaceEditWm builder(BuildContext context) => PlaceEditWm._(
        WidgetModelDependencies(
          errorHandler: context.read<StandartErrorHandler>(),
        ),
        context.read<PlaceInteractor>(),
        context.read<LocationRepository>(),
        (context.widget as PlaceEditScreen).place,
      );

  /// Интеракторы, репозитории.
  final PlaceInteractor placeInteractor;
  final LocationRepository locationRepository;

  /// Переданное место.
  final EntityStreamedState<Place?> placeState;

  /// Тип места.
  final EntityStreamedState<PlaceTypeUi?> placeTypeState;

  /// Фотографии.
  final EntityStreamedState<UnmodifiableListView<String>> photosState;

  /// Создаём новое место или редактируем существующее?
  bool get isNew => placeState.value.data == null;

  /// Добавляет фотографию.
  void addPhoto(String url) {
    final newPhotos = List<String>.from(photosState.value.data)..add(url);
    photosState.content(UnmodifiableListView(newPhotos));
  }

  /// Удаляет фотографию.
  void removePhoto(String url) {
    final newPhotos = List<String>.from(photosState.value.data)..remove(url);
    photosState.content(UnmodifiableListView(newPhotos));
  }

  /// Сохраняет место.
  Future<Place> savePlace({
    required String name,
    required Coord coord,
    required String description,
  }) async {
    await placeState.loading();

    var id = placeState.value.data?.id;

    final newPlace = Place(
      id: id ?? 0,
      name: name,
      coord: coord,
      photos: photosState.value.data,
      description: description,
      type: placeTypeState.value.data!.type,
      userInfo: PlaceUserInfo.zero,
      calDistanceFrom: locationRepository.location,
    );

    if (id == null) {
      id = await placeInteractor.addNewPlace(newPlace);
    } else {
      await placeInteractor.updatePlace(newPlace);
    }

    await placeState.content(newPlace);

    return newPlace;
  }
}
