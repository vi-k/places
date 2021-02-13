import 'package:flutter/material.dart';

import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_extended.dart';
import 'package:places/data/repository/base/filter.dart';
import 'package:places/main.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/place_card_grid.dart';
import 'package:places/ui/widget/failed.dart';
import 'package:places/ui/widget/loader.dart';
import 'package:places/ui/widget/place_card.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/sliver_floating_header.dart';

import 'search_screen.dart';
import 'sight_edit_screen.dart';

/// Экран списка мест.
class PlaceListScreen extends StatefulWidget {
  @override
  _PlaceListScreenState createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  // Пока фильтр храним в main.dart
  // Filter filter = Filter();

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
      body: Loader<List<Place>>(
        load: () => placeInteractor.getPlaces(filter),
        error: (context, error) => Failed(
          error.toString(),
          onRepeat: () => Loader.of<List<Place>>(context).reload(),
        ),
        builder: (context, _, places) => CustomScrollView(
          slivers: [
            _buildHeader(context, theme, columnsCount),
            PlaceCardGrid(
              cardType: Favorite.no,
              places: places,
              asSliver: true,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: columnsCount == 2
          ? FloatingActionButton(
              onPressed: () => Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SightEditScreen(),
                ),
              ),
              child: const Icon(Icons.add),
            )
          : FloatingActionButton.extended(
              isExtended: true,
              onPressed: () => Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SightEditScreen(),
                ),
              ),
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
            final newFilter = await Navigator.push<Filter>(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(filter: filter),
              ),
            );
            if (newFilter != null) {
              filter = newFilter;
              print('Filter changed: $filter');
              Loader.of<List<Place>>(context).reload();
            }
          },
          filter: filter,
          onChanged: (newFilter) {
            filter = newFilter;
            print('Filter changed: $filter');
            Loader.of<List<Place>>(context).reload();
          },
        ),
        bottomHeight: smallButtonHeight,
      );
}
