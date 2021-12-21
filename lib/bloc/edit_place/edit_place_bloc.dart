import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pedantic/pedantic.dart';
import 'package:places/bloc/form_value.dart';
import 'package:places/bloc/form_values.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/photo.dart';
import 'package:places/data/model/place_base.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/repositories/location/location_repository.dart';
import 'package:places/data/repositories/place/repository_exception.dart';
import 'package:places/data/repositories/upload/upload_repository.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/utils/coord.dart';

part 'edit_place_event.dart';
part 'edit_place_state.dart';

/// BLoC для редактирования места.
class EditPlaceBloc extends Bloc<EditPlaceEvent, EditPlaceState> {
  EditPlaceBloc(
    this._placeInteractor,
    this._uploadRepository,
    this._locationRepository,
    this._id,
  ) : super(EditPlaceState.init(
          _id == 0 ? FormValueState.underway : FormValueState.undefined,
        ));

  final PlaceInteractor _placeInteractor;
  final UploadRepository _uploadRepository;
  final LocationRepository _locationRepository;
  int _id;

  int get id => _id;
  bool get isNew => _id == 0;

  @override
  Stream<EditPlaceState> mapEventToState(
    EditPlaceEvent event,
  ) async* {
    if (event is EditPlaceStarted) {
      if (isNew) {
        yield* _setLocation();
      } else {
        yield* _load();
      }
    } else if (event is EditPlaceSetLocation) {
      yield* _setLocation();
    } else if (event is EditPlacePhotoAdded) {
      yield* _addPhoto(event);
    } else if (event is EditPlacePhotoRemoved) {
      yield* _removePhoto(event);
    } else if (event is EditPlaceChanged) {
      yield* _setValues(event);
    } else if (event is EditPlaceFinished) {
      yield* _save();
    }
  }

  // Устанавливает начальные координаты.
  Stream<EditPlaceState> _setLocation() async* {
    yield state.copyWith(
      lat: state.lat.toUndefined(),
      lon: state.lon.toUndefined(),
    );

    unawaited(_setLocationAsync());
  }

  // Устанавливает начальные координаты (вне mapEventToState).
  Future<void> _setLocationAsync() async {
    final location = await _locationRepository.getLocation();
    if (location != null && state.lat.isUndefined && state.lon.isUndefined) {
      emit(state.copyWith(
        lat: _validateLatValue(state.lat, location.lat),
        lon: _validateLonValue(state.lon, location.lon),
      ));
    }
  }

  // Загружает данные о месте.
  Stream<EditPlaceState> _load() async* {
    yield EditPlaceLoadInProgress(state);
    try {
      final place = await _placeInteractor.getPlace(_id);
      yield state.copyWith(
        name: FormValue.valid(place.name),
        type: FormValue.valid(place.type),
        lat: FormValue.valid(place.coord.lat.toStringAsFixed(6)),
        lon: FormValue.valid(place.coord.lon.toStringAsFixed(6)),
        photos:
            FormValue.valid(place.photos.map((e) => Photo(url: e)).toList()),
        description: FormValue.valid(place.description),
      );
    } on RepositoryException catch (error) {
      yield EditPlaceLoadFailure(state, error);
    }
  }

  // Добавляет фотографию.
  Stream<EditPlaceState> _addPhoto(EditPlacePhotoAdded event) async* {
    final newPhotos = List<Photo>.from(state.photos.value)..add(event.photo);
    yield state.copyWith(
      photos: _validatePhotos(state.photos.setValue(newPhotos)),
    );

    // Если добавлено незагруженное фото, запускаем загрузку.
    final path = event.photo.path;
    if (path != null) {
      unawaited(_uploadPhotoAsync(path));
    }
  }

  // Добавляет фотографию (после mapEventToState).
  Future<void> _uploadPhotoAsync(String path) async {
    try {
      final url = await _uploadRepository.uploadPhoto(File(path));
      if (url == null) return;

      // Пока загружали картинку, список фотографий мог измениться.
      final newPhotos = List<Photo>.from(state.photos.value);
      final index = newPhotos.indexWhere((photo) => photo.path == path);
      // Фотография могла быть удалена.
      if (index == -1) return;

      newPhotos[index] = Photo(url: url);
      emit(state.copyWith(
        photos: _validatePhotos(state.photos.setValue(newPhotos)),
      ));
    } on RepositoryException catch (error) {
      emit(EditPlaceLoadFailure(state, error));
    }
  }

  // Удаляет фотографию.
  Stream<EditPlaceState> _removePhoto(EditPlacePhotoRemoved event) async* {
    try {
      final newPhotos = List<Photo>.from(state.photos.value)
        ..remove(event.photo);
      yield state.copyWith(
        photos: _validatePhotos(state.photos.setValue(newPhotos)),
      );
    } on RepositoryException catch (error) {
      yield EditPlaceLoadFailure(state, error);
    }
  }

  // Устанавливает значения полей.
  Stream<EditPlaceState> _setValues(EditPlaceChanged event) async* {
    try {
      yield state.copyWith(
        name: event.name == null
            ? null
            : _validateName(state.name.setValue(event.name!)),
        type: event.type == null
            ? null
            : _validateType(state.type.setValue(event.type)),
        lat: event.lat != null
            ? _validateLat(state.lat.setValue(event.lat!))
            : event.coord != null
                ? _validateLatValue(state.lat, event.coord!.lat)
                : event.lon != null
                    ? _validateLat(state.lat)
                    : null,
        lon: event.lon != null
            ? _validateLon(state.lon.setValue(event.lon!))
            : event.coord != null
                ? _validateLonValue(state.lon, event.coord!.lon)
                : event.lat != null
                    ? _validateLon(state.lon)
                    : null,
        description: event.description == null
            ? null
            : state.description.setValue(event.description!).toValid(),
      );
    } on RepositoryException catch (error) {
      yield EditPlaceLoadFailure(state, error);
    }
  }

  // Сохраняет изменения.
  Stream<EditPlaceState> _save() async* {
    final checkedState = state.copyWith(
      name: _validateName(state.name),
      type: _validateType(state.type),
      lat: _validateLat(state.lat),
      lon: _validateLon(state.lon),
      photos: _validatePhotos(state.photos, toSave: true),
      description: state.description.toValid(),
    );

    if (checkedState.isNotValid) {
      yield checkedState;

      return;
    }

    yield EditPlaceLoadInProgress(checkedState);

    final place = PlaceBase(
      id: _id,
      name: checkedState.name.value,
      coord: Coord(
        double.parse(checkedState.lat.value),
        double.parse(checkedState.lon.value),
      ),
      photos: checkedState.photos.value.map((e) => e.url!).toList(),
      description: checkedState.description.value,
      type: checkedState.type.value!,
    );

    try {
      if (isNew) {
        final newPlace = await _placeInteractor.addNewPlace(place);
        _id = newPlace.id;
      } else {
        await _placeInteractor.updatePlace(place);
      }

      final savedState = checkedState.copyWith(
        name: checkedState.name.toSaved(),
        type: checkedState.type.toSaved(),
        lat: checkedState.lat.toSaved(),
        lon: checkedState.lon.toSaved(),
        photos: checkedState.photos.toSaved(),
        description: checkedState.description.toSaved(),
      );

      yield EditPlaceSaveSuccess(savedState);
    } on RepositoryException catch (error) {
      yield EditPlaceSaveFailure(checkedState, error);
    }
  }

  // Проверяет имя.
  FormValue<String> _validateName(FormValue<String> name) => name.value.isEmpty
      ? name.toInvalid(error: stringRequiredField)
      : name.toValid();

  // Проверяет имя.
  FormValue<PlaceType?> _validateType(FormValue<PlaceType?> type) =>
      type.value == null
          ? type.toUndefined(error: stringRequiredField)
          : type.toValid();

  // Проверяет широту.
  FormValue<String> _validateLat(FormValue<String> lat) {
    if (lat.value.isEmpty) {
      return lat.toInvalid(error: stringRequiredField);
    }

    final latitude = double.tryParse(lat.value);
    if (latitude == null || latitude < -90 || latitude > 90) {
      return lat.toInvalid(error: stringInvalidValue);
    }

    return lat.toValid();
  }

  // Проверяет широту.
  FormValue<String> _validateLatValue(FormValue<String> lat, double latitude) {
    final newLat = lat.setValue(_coordToString(latitude));
    if (latitude < -90 || latitude > 90) {
      return newLat.toInvalid(error: stringInvalidValue);
    }

    return newLat.toValid();
  }

  // Проверяет долготу.
  FormValue<String> _validateLon(FormValue<String> lon) {
    if (lon.value.isEmpty) {
      return lon.toInvalid(error: stringRequiredField);
    }

    final longitude = double.tryParse(lon.value);
    if (longitude == null || longitude < -180 || longitude > 180) {
      return lon.toInvalid(error: stringInvalidValue);
    }

    return lon.toValid();
  }

  // Проверяет широту.
  FormValue<String> _validateLonValue(FormValue<String> lon, double longitude) {
    final newLon = lon.setValue(_coordToString(longitude));
    if (longitude < -180 || longitude > 180) {
      return newLon.toInvalid(error: stringInvalidValue);
    }

    return newLon.toValid();
  }

  // Проверяет, все ли фотографии загружены.
  FormValue<List<Photo>> _validatePhotos(
    FormValue<List<Photo>> photos, {
    bool toSave = false,
  }) {
    final loaded = photos.value.where((photo) => !photo.isLoaded).isEmpty;

    return photos.value.isEmpty
        ? photos.toInvalid(error: stringInvalidPhotos)
        : loaded
            ? photos.toValid()
            : toSave
                ? photos.toInvalid(error: stringWaitForUploading)
                : photos.toUnderway();
  }

  String _coordToString(double value) => value.toStringAsFixed(6);
}
