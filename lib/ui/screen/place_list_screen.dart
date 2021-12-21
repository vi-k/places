import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/places/places_bloc.dart';
import 'package:places/data/model/place.dart';
import 'package:places/environment/build_type.dart';
import 'package:places/environment/environment.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
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
  final _controller = ScrollController();
  var _scrollInitialized = false;

  PlacesBloc get bloc => context.read<PlacesBloc>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_scrollInitialized) {
        bloc.add(PlacesScrollChanged(_controller.position.pixels));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    final columnsCount = aspectRatio <= 4 / 5
        ? 1
        : aspectRatio <= 5 / 4
            ? 2
            : 3;

    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          _buildHeader(columnsCount),
          BlocBuilder<PlacesBloc, PlacesState>(
            builder: (context, state) {
              if (state is PlacesLoadInProgress || state.places.isNotReady) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is PlacesLoadFailure) {
                return SliverToBoxAdapter(
                  child: Failed(
                    svg: Svg64.delete,
                    title: stringError,
                    message: state.error.toString(),
                    onRepeat: () => bloc.add(const PlacesRerfreshed()),
                  ),
                );
              }

              // Восстановление позиции скролла. К сожалению, только здесь.
              if (!_scrollInitialized) {
                Future<void>(() {
                  _controller.jumpTo(state.scrollOffset.value);
                  _scrollInitialized = true;
                });
              }

              return PlaceCardGrid(
                cardType: Favorite.no,
                places: state.places.value,
                asSliver: true,
                onCardClose: Environment.buildType == BuildType.dev
                    ? (place) => _deletePlace(context, place)
                    : null,
              );
            },
          ),
        ],
      ),

      // body: NestedScrollView(
      //   controller: _controller,
      //   floatHeaderSlivers: true,
      //   headerSliverBuilder: (context, innerBoxScrolled) => [
      //     _buildHeader(columnsCount),
      //   ],
      //   body: BlocBuilder<PlacesBloc, PlacesState>(
      //     builder: (context, state) {
      //       if (state is PlacesLoadInProgress || state.places.isNotReady) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }

      //       if (state is PlacesLoadFailure) {
      //         return Failed(
      //           svg: Svg64.delete,
      //           title: stringError,
      //           message: state.error.toString(),
      //           onRepeat: () => bloc.add(const PlacesRerfreshed()),
      //         );
      //       }

      //       // Восстановление позиции скролла. К сожалению, только здесь.
      //       if (!_scrollInitialized) {
      //         Future<void>(() {
      //           _controller.jumpTo(state.scrollOffset.value);
      //           _scrollInitialized = true;
      //         });
      //       }

      //       return RefreshIndicator(
      //         onRefresh: () async => bloc.add(const PlacesRerfreshed()),
      //         child: state.places.value.isEmpty
      //             ? const Failed(
      //                 svg: Svg64.search,
      //                 title: stringNothingFound,
      //                 message: stringNothingFoundMessage,
      //               )
      //             : CustomScrollView(
      //                 slivers: [
      //                   PlaceCardGrid(
      //                     cardType: Favorite.no,
      //                     places: state.places.value,
      //                     asSliver: true,
      //                     onCardClose: (place) => _deletePlace(context, place),
      //                   ),
      //                 ],
      //               ),
      //       );
      //     },
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
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
          builder: (_, state) => state.filter.isNotReady
              ? const SizedBox()
              : SearchBar(
                  key: ValueKey(state.filter),
                  onTap: () => SearchScreen.start(context),
                  filter: state.filter.value,
                  onFilterChanged: (filter) =>
                      bloc.add(PlacesFilterChanged(filter)),
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
      bloc.add(PlacesPlaceRemoved(place));
    }
  }
}
