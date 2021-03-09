import 'dart:collection';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/repository/base/location_repository.dart';
import 'package:places/error_handler.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/widget/get_image.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/focus.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:relation/relation.dart';

import 'place_edit_screen.dart';
import 'place_type_select_screen.dart';

/// WidgetModel для PlaceEditScreen
class PlaceEditWm extends WidgetModel {
  PlaceEditWm._(
    this.context,
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
        super(baseDependencies) {
    if (place != null) {
      nameController.text = place.name;
      latController.text = place.coord.lat.toStringAsFixed(6);
      lonController.text = place.coord.lon.toStringAsFixed(6);
      descriptionController.text = place.description;
    }
  }

  // ignore: prefer_constructors_over_static_methods
  static PlaceEditWm builder(BuildContext context) => PlaceEditWm._(
        context,
        WidgetModelDependencies(
          errorHandler: context.read<StandartErrorHandler>(),
        ),
        context.read<PlaceInteractor>(),
        context.read<LocationRepository>(),
        (context.widget as PlaceEditScreen).place,
      );

  /// Контекст для диалогов и снекбаров.
  final BuildContext context;

  /// Интеракторы, репозитории.
  final PlaceInteractor placeInteractor;
  final LocationRepository locationRepository;

  /// Переданное место.
  final EntityStreamedState<Place?> placeState;

  /// Тип места.
  final EntityStreamedState<PlaceTypeUi?> placeTypeState;

  /// Фотографии.
  final EntityStreamedState<UnmodifiableListView<String>> photosState;

  /// Ключи и контроллеры.
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  /// Создаём новое место или редактируем существующее?
  bool get isNew => placeState.value.data == null;

  /// Удаляет фотографию.
  void removePhoto(String url) {
    final newPhotos = List<String>.from(photosState.value.data)..remove(url);
    photosState.content(UnmodifiableListView(newPhotos));
  }

  /// Сохраняет место.
  Future<Place> save() async {
    var id = placeState.value.data?.id;

    await placeState.loading();

    final newPlace = Place(
      id: id ?? 0,
      name: nameController.text,
      coord: Coord(
        double.parse(latController.text),
        double.parse(lonController.text),
      ),
      photos: photosState.value.data,
      description: descriptionController.text,
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

  bool _cmpLists(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final bi = b.iterator;
    for (final va in a) {
      bi.moveNext();
      if (va != bi.current) return false;
    }

    return true;
  }

  // Проверяет данные перед сохранением.
  bool validate() {
    if (!formKey.currentState!.validate()) return false;

    // Если не выбран тип места, предупреждаем об этом пользователя
    // и отправляем его на страницу выбора типа.
    if (placeTypeState.value.data == null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(stringNoPlaceType)));
      getPlaceType();
      return false;
    }

    return true;
  }

  // Проверяет, нужно ли сохранять.
  bool needSave({bool forced = false}) {
    formKey.currentState!.save();

    if (isNew) return true;

    final place = placeState.value.data!;

    return forced ||
        place.name != nameController.text ||
        place.type != placeTypeState.value.data?.type ||
        place.coord.lat != double.parse(latController.text) ||
        place.coord.lon != double.parse(lonController.text) ||
        place.description != descriptionController.text ||
        !_cmpLists(place.photos, photosState.value.data);
  }

  // Получает тип места.
  Future<void> getPlaceType() async {
    final placeType = await Navigator.push<PlaceType>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlaceTypeSelectScreen(placeType: placeTypeState.value.data?.type),
      ),
    );

    if (placeType != null) {
      await placeTypeState.content(PlaceTypeUi(placeType));
    }
  }

  // Валидатор названия.
  String? nameValidator(String? value) =>
      value!.isEmpty ? stringRequiredField : null;

  // Валадитор координат.
  String? latValidator(String? value) {
    if (value == null || value.isEmpty) {
      return stringRequiredField;
    }

    final lat = double.tryParse(value);
    if (lat == null || lat < -90 || lat > 90) {
      return stringInvalidValue;
    }

    return null;
  }

  // Валадитор координат.
  String? lonValidator(String? value) {
    if (value == null || value.isEmpty) {
      return stringRequiredField;
    }

    final lon = double.tryParse(value);
    if (lon == null || lon < -180 || lon > 180) {
      return stringInvalidValue;
    }

    return null;
  }

  // Добавляет фотографию.
  Future<void> addPhoto() async {
    final url = await showModalBottomSheet<String>(
      context: context,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      builder: (context) => GetImage(),
    );

    if (url == null) return;

    final newPhotos = List<String>.from(photosState.value.data)..add(url);
    await photosState.content(UnmodifiableListView(newPhotos));
  }

  // Завершает редактирование.
  Future<void> done() async {
    if (!validate()) return;
    // Сохраняем и возвращаемся.
    Navigator.pop(context, needSave(forced: true) ? await save() : null);
  }

  // Переходит на следующий TextField.
  void nextEditableTextFocus() =>
      FocusScope.of(context).nextEditableTextFocus();

  // Калбэк для проверки - можем ли мы вернуться - и для передачи места,
  // если оно было изменено.
  Future<bool> onWillPop() async {
    if (!validate()) {
      final exit = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(stringDoCancel),
          actions: [
            SmallButton(
              label: stringCancel,
              onPressed: () => Navigator.pop(context, false),
            ),
            SmallButton(
              label: stringYes,
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      return exit ?? false;
    }

    if (!needSave()) return true;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? stringDoCreate : stringDoSave),
        actions: [
          SmallButton(
            label: stringNo,
            onPressed: () {
              // Закрываем диалог.
              Navigator.pop(context);
              // Возвращаемся назад без сохранения изменений.
              Navigator.pop(context, null);
            },
          ),
          SmallButton(
            label: stringYes,
            onPressed: () async {
              final place = await save();
              // Закрываем диалог.
              Navigator.pop(context);
              // Возвращаемся назад с сохранением изменений.
              Navigator.pop(context, place);
            },
          ),
        ],
      ),
    );

    return false;
  }
}
