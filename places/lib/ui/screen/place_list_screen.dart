import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/data/model/place.dart';
import 'package:places/main.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/loader.dart';
import 'package:places/ui/widget/place_card_grid.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/sliver_floating_header.dart';
import 'package:places/utils/let_and_also.dart';

import 'place_edit_screen.dart';
import 'search_screen.dart';

/// Экран списка мест.
class PlaceListScreen extends StatefulWidget {
  @override
  _PlaceListScreenState createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  final placesController = StreamController<List<Place>?>();
  List<Place>? lastPlaces;

  Future<void> reloadPlaces() async {
    placesController.add(null);
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    final places = await placeInteractor.getPlaces(filter);
    placesController.add(places);
  }

  @override
  void initState() {
    super.initState();

    reloadPlaces();
  }

  @override
  void dispose() {
    placesController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    final columnsCount = aspectRatio <= 4 / 5
        ? 1
        : aspectRatio <= 5 / 4
            ? 2
            : 3;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          _buildHeader(context, theme, columnsCount),
        ],
        body: RefreshIndicator(
          onRefresh: reloadPlaces,
          child: StreamBuilder<List<Place>?>(
            stream: placesController.stream,
            builder: (context, snapshot) {
              lastPlaces ??= snapshot.data;
              return lastPlaces == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomScrollView(
                      slivers: [
                        PlaceCardGrid(
                          cardType: Favorite.no,
                          places: lastPlaces,
                          asSliver: true,
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
  }

  Widget _buildHeader(
          BuildContext context, MyThemeData theme, int columnsCount) =>
      SliverFloatingHeader(
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
          onFilterChanged: (newFilter) {
            filter = newFilter;
            Loader.of<List<Place>>(context).reload();
          },
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
