import 'package:flutter/material.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/place_card_grid.dart';
import 'package:places/ui/widget/failed.dart';
import 'package:places/ui/widget/loader.dart';
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
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placeInteractor = context.read<PlaceInteractor>();

    return Scaffold(
      appBar: SmallAppBar(
        title: stringFavorite,
        bottom: Padding(
          padding: commonPaddingLBR,
          child: TabSwitch(
            tabs: _tabs,
            tabController: tabController,
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Tab(
            child: Loader<List<Place>>(
              load: placeInteractor.getWishlist,
              error: (context, error) => Failed(
                message: error.toString(),
                onRepeat: () => Loader.of<List<Place>>(context).reload(),
              ),
              builder: (context, _, places) => PlaceCardGrid(
                cardType: Favorite.wishlist,
                places: places,
              ),
            ),
          ),
          Tab(
            child: Loader<List<Place>>(
              load: placeInteractor.getVisited,
              error: (context, error) => Failed(
                message: error.toString(),
                onRepeat: () => Loader.of<List<Place>>(context).reload(),
              ),
              builder: (context, _, places) => PlaceCardGrid(
                cardType: Favorite.visited,
                places: places,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppNavigationBar(index: 2),
    );
  }
}
