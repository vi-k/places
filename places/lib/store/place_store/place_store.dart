// ignore: import_of_legacy_library_into_null_safe
import 'package:mobx/mobx.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/base/filter.dart';

part 'place_store.g.dart';

/// Store для mobx.
///
/// Создан в академических целях. Не поддерживает обработку ошибок.
class PlaceStore = PlaceStoreBase with _$PlaceStore;

abstract class PlaceStoreBase with Store {
  PlaceStoreBase(this.placeInteractor);

  final PlaceInteractor placeInteractor;

  /// Список мест, зависящий от фильтра.
  @observable
  ObservableFuture<List<Place>> places = ObservableFuture.value(null);

  /// Состояние загрузки.
  @observable
  bool isLoading = false;

  /// Фильтр.
  @observable
  Filter filter = Filter();

  /// Применяет фильтр, загружает новый список.
  @action
  Future<void> applyFilter(Filter filter) async {
    isLoading = true;
    this.filter = filter;
    places = ObservableFuture.value(await placeInteractor.getPlaces(filter));
    isLoading = false;
  }
}
