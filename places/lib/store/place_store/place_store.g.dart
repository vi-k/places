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

  final _$PlaceStoreBaseActionController =
      ActionController(name: 'PlaceStoreBase');

  @override
  void applyFilter(Filter filter) {
    final _$actionInfo = _$PlaceStoreBaseActionController.startAction(
        name: 'PlaceStoreBase.applyFilter');
    try {
      return super.applyFilter(filter);
    } finally {
      _$PlaceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
places: ${places},
filter: ${filter}
    ''';
  }
}
