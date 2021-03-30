import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';

part 'edit_place_event.dart';
part 'edit_place_state.dart';

/// BLoC для редактирования места.
///
/// Не хранит в себе информации о месте. Нужен только для добавления или
/// изменения места и отображения процесса сохранения места.
class EditPlaceBloc extends Bloc<EditPlaceEvent, EditPlaceState> {
  EditPlaceBloc(this._placeInteractor) : super(const EditPlaceEditing());

  final PlaceInteractor _placeInteractor;

  @override
  Stream<EditPlaceState> mapEventToState(
    EditPlaceEvent event,
  ) async* {
    if (event is EditPlaceAdd) {
      yield* _add(event);
    } else if (event is EditPlaceUpdate) {
      yield* _update(event);
    }
  }

  Stream<EditPlaceState> _add(EditPlaceAdd event) async* {
    yield const EditPlaceLoading();
    final place = await _placeInteractor.addNewPlace(event.place);
    yield EditPlaceSaved(place);
  }

  Stream<EditPlaceState> _update(EditPlaceUpdate event) async* {
    yield const EditPlaceLoading();
    await Future<void>.delayed(const Duration(seconds: 2));
    await _placeInteractor.updatePlace(event.place);
    yield EditPlaceSaved(event.place);
  }
}
