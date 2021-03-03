import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/base/filter.dart';
import 'package:places/store/place_store/place_store.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/loader.dart';
import 'package:places/ui/widget/place_card_grid.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/sliver_floating_header.dart';
import 'package:provider/provider.dart';

import 'place_edit_screen.dart';
import 'search_screen.dart';

/// Экран списка мест.
class PlaceListScreen extends StatefulWidget {
  @override
  _PlaceListScreenState createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    final columnsCount = aspectRatio <= 4 / 5
        ? 1
        : aspectRatio <= 5 / 4
            ? 2
            : 3;

    return Provider(
      create: (_) =>
          PlaceStore(context.read<PlaceInteractor>())..applyFilter(Filter()),
      child: Observer(
        builder: (context) {
          final placeStore = context.read<PlaceStore>();

          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxScrolled) => [
                _buildHeader(context, theme, columnsCount, placeStore,
                    placeStore.filter),
              ],
              body: placeStore.places.status == FutureStatus.pending
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () async =>
                          Loader.of<List<Place>>(context).reload(),
                      child: CustomScrollView(
                        slivers: [
                          PlaceCardGrid(
                            cardType: Favorite.no,
                            places: placeStore.places.value,
                            asSliver: true,
                          ),
                        ],
                      ),
                    ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: columnsCount == 2
                ? FloatingActionButton(
                    onPressed: () => _newPlace(context),
                    child: const Icon(Icons.add),
                  )
                : FloatingActionButton.extended(
                    isExtended: true,
                    onPressed: () => _newPlace(context),
                    icon: const Icon(Icons.add),
                    label: Text(stringNewPlace.toUpperCase()),
                  ),
            bottomNavigationBar: const AppNavigationBar(index: 0),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    MyThemeData theme,
    int columnsCount,
    PlaceStore placeStore,
    Filter filter,
  ) =>
      SliverFloatingHeader(
        key: ValueKey(filter),
        title: stringPlaceList,
        bottom: SearchBar(
          onTap: () async {
            await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
          },
          filter: filter,
          onFilterChanged: placeStore.applyFilter,
        ),
        bottomHeight: smallButtonHeight,
      );

  Future<void> _newPlace(BuildContext context) async {
    final place = await Navigator.push<Place>(
        context,
        MaterialPageRoute(
          builder: (context) => const PlaceEditScreen(),
        ));
    if (place != null) Loader.of<List<Place>>(context).reload();
  }
}
