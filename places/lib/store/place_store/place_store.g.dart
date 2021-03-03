// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PlaceStore on PlaceStoreBase, Store {
  final _$placesAtom = Atom(name: 'PlaceStoreBase.places');

  @override
  ObservableFuture<List<Place>> get places {
    _$placesAtom.reportRead();
    return super.places;
  }

  @override
  set places(ObservableFuture<List<Place>> value) {
    _$placesAtom.reportWrite(value, super.places, () {
      super.places = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'PlaceStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$filterAtom = Atom(name: 'PlaceStoreBase.filter');

  @override
  Filter get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(Filter value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  final _$applyFilterAsyncAction = AsyncAction('PlaceStoreBase.applyFilter');

  @override
  Future<void> applyFilter(Filter filter) {
    return _$applyFilterAsyncAction.run(() => super.applyFilter(filter));
  }

  @override
  String toString() {
    return '''
places: ${places},
isLoading: ${isLoading},
filter: ${filter}
    ''';
  }
}
