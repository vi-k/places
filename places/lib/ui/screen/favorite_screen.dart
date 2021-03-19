import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/wishlist_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
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
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

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
          _buildTab(placeInteractor, Favorite.wishlist),
          _buildTab(placeInteractor, Favorite.visited),
        ],
      ),
      bottomNavigationBar: const AppNavigationBar(index: 2),
    );
  }

  Widget _buildTab(PlaceInteractor placeInteractor, Favorite listType) => Tab(
        child: BlocProvider<WishlistBloc>(
          create: (_) =>
              WishlistBloc(placeInteractor, listType)..add(WishlistLoad()),
          child: BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              if (state is WishlistLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is WishlistReady) {
                return PlaceCardGrid(
                  cardType: listType,
                  places: state.places,
                );
              }

              // Оставляю WishlistInitial, чтобы не забывать отправлять
              // первое событие.
              return const Failed(message: stringUnknownState);
            },
          ),
        ),
      );
}
