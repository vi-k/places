import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app_bloc.dart';
import 'package:places/bloc/places_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
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
import 'package:places/utils/let_and_also.dart';

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

    return BlocProvider<PlacesBloc>(
      create: (_) => PlacesBloc(
        context.read<PlaceInteractor>(),
        context.read<AppBloc>().settings.filter,
      )..add(const PlacesReload()),
      child: BlocBuilder<PlacesBloc, PlacesState>(
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
                              ),
                            ],
                          ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
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
        ),
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
            context.read<AppBloc>().let((it) {
              it.add(AppChangeSettings(it.settings.copyWith(filter: filter)));
            });
          },
        ),
        bottomHeight: smallButtonHeight,
      );

  Future<void> _newPlace(BuildContext context) async {
    final place = await standartNavigatorPush<Place>(
        context, () => const PlaceEditScreen());

    if (place != null) {
      context.read<PlacesBloc>().add(const PlacesReload());
    }
  }
}
