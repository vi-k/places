import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/favorite/favorite_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/place_card_grid.dart';
import 'package:places/ui/widget/failed.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/tab_switch.dart';
import 'package:provider/provider.dart';

/// Экран "Избранное".
class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  static const _tabs = [stringWishlistName, stringVisitedName];
  late final TabController _tabController = TabController(
    length: _tabs.length,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placeInteractor = context.watch<PlaceInteractor>();

    return Scaffold(
      appBar: SmallAppBar(
        title: stringFavorite,
        bottom: Padding(
          padding: commonPaddingLBR,
          child: TabSwitch(
            tabs: _tabs,
            tabController: _tabController,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWishlistTab(placeInteractor),
          _buildVisitedTab(placeInteractor),
        ],
      ),
      bottomNavigationBar: const AppNavigationBar(index: 2),
    );
  }

  Widget _buildWishlistTab(PlaceInteractor placeInteractor) => Tab(
        child: BlocBuilder<WishlistBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoadFailure) {
              return Failed(
                svg: Svg64.delete,
                title: stringError,
                message: state.error.toString(),
                onRepeat: () =>
                    context.read<WishlistBloc>().add(const FavoriteStarted()),
              );
            }

            if (state is FavoriteLoadInProgress || state.places.isNotReady) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return state.places.value.isEmpty
                ? const Failed(
                    svg: Svg64.card,
                    title: stringEmpty,
                    message: stringWishlistMessage,
                  )
                : PlaceCardGrid(
                    cardType: Favorite.wishlist,
                    places: state.places.value,
                    onCardClose: (place) => context
                        .read<WishlistBloc>()
                        .add(FavoritePlaceRemoved(place)),
                  );
          },
        ),
      );

  Widget _buildVisitedTab(PlaceInteractor placeInteractor) => Tab(
        child: BlocBuilder<VisitedBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoadFailure) {
              return Failed(
                svg: Svg64.delete,
                title: stringError,
                message: state.error.toString(),
                onRepeat: () =>
                    context.read<VisitedBloc>().add(const FavoriteStarted()),
              );
            }

            if (state is FavoriteLoadInProgress || state.places.isNotReady) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return state.places.value.isEmpty
                ? const Failed(
                    svg: Svg64.go,
                    title: stringEmpty,
                    message: stringVisitedMessage,
                  )
                : PlaceCardGrid(
                    cardType: Favorite.visited,
                    places: state.places.value,
                    onCardClose: (place) => context
                        .read<VisitedBloc>()
                        .add(FavoritePlaceMoved(place)),
                  );
          },
        ),
      );
}
