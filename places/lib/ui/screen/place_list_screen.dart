import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/places/places_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
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
  PlacesBloc get bloc => context.read<PlacesBloc>();

  @override
  Widget build(BuildContext context) {
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    final columnsCount = aspectRatio <= 4 / 5
        ? 1
        : aspectRatio <= 5 / 4
            ? 2
            : 3;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          _buildHeader(columnsCount),
        ],
        body: BlocBuilder<PlacesBloc, PlacesState>(
          builder: (context, state) {
            if (state is PlacesLoadingFailed) {
              return Failed(
                svg: Svg64.delete,
                title: stringError,
                message: state.error.toString(),
                onRepeat: () => bloc.add(const PlacesReload()),
              );
            }

            if (state.places == null || state is PlacesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => bloc.add(const PlacesReload()),
              child: state.places!.isEmpty
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
                          onCardClose: (place) => _deletePlace(context, place),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: columnsCount == 2
          ? FloatingActionButton(
              onPressed: () => PlaceEditScreen.start(context),
              child: const Icon(Icons.add),
            )
          : FloatingActionButton.extended(
              isExtended: true,
              onPressed: () => PlaceEditScreen.start(context),
              icon: const Icon(Icons.add),
              label: Text(stringNewPlace.toUpperCase()),
            ),
      bottomNavigationBar: const AppNavigationBar(index: 0),
    );
  }

  Widget _buildHeader(int columnsCount) => SliverFloatingHeader(
        title: stringPlaceList,
        bottom: BlocBuilder<PlacesBloc, PlacesState>(
          buildWhen: (previous, current) => previous.filter != current.filter,
          builder: (_, state) => state.filter == null
              ? const SizedBox()
              : SearchBar(
                  key: ValueKey(state.filter),
                  onTap: () => standartNavigatorPush<String>(
                      context, () => const SearchScreen()),
                  filter: state.filter!,
                  onFilterChanged: (filter) => bloc.add(PlacesLoad(filter)),
                ),
        ),
        bottomHeight: smallButtonHeight,
      );

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
      bloc.add(PlacesRemove(place));
    }
  }
}
