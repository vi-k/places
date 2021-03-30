import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/bloc/places/places_bloc.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/failed.dart';
import 'package:places/ui/widget/place_card_grid.dart';
import 'package:places/ui/widget/search_bar.dart';
import 'package:places/ui/widget/sliver_floating_header.dart';
import 'package:places/ui/widget/small_button.dart';

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
    final theme = context.watch<AppBloc>().theme;
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    final columnsCount = aspectRatio <= 4 / 5
        ? 1
        : aspectRatio <= 5 / 4
            ? 2
            : 3;

    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            _buildHeader(context, theme, columnsCount, state.filter),
          ],
          body: state is PlacesReady
              ? RefreshIndicator(
                  onRefresh: () async =>
                      context.read<PlacesBloc>().add(const PlacesReload()),
                  child: state.places.isEmpty
                      ? const Failed(
                          svg: Svg64.search,
                          title: stringNothingFound,
                          message: stringNothingFoundMessage,
                        )
                      : CustomScrollView(
                          slivers: [
                            PlaceCardGrid(
                              cardType: Favorite.no,
                              places: state.places,
                              asSliver: true,
                              onCardClose: (place) =>
                                  _deletePlace(context, place),
                            ),
                          ],
                        ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
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
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    MyThemeData theme,
    int columnsCount,
    Filter filter,
  ) =>
      SliverFloatingHeader(
        key: ValueKey(filter),
        title: stringPlaceList,
        bottom: SearchBar(
          onTap: () => standartNavigatorPush<String>(
              context, () => const SearchScreen()),
          filter: filter,
          onFilterChanged: (filter) {
            context.read<PlacesBloc>().add(PlacesLoad(filter));
            context.read<AppBloc>().add(AppChangeSettings(filter: filter));
          },
        ),
        bottomHeight: smallButtonHeight,
      );

  void _newPlace(BuildContext context) {
    standartNavigatorPush<Place>(context, () => const PlaceEditScreen(null));
  }

  Future<void> _deletePlace(BuildContext context, Place place) async {
    final doDelete = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(stringDoDelete),
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
        ) ??
        false;

    if (doDelete) {
      context.read<PlacesBloc>().add(PlacesRemove(place));
    }
  }
}
