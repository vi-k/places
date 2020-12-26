/// Экран: Хочу посетить/Посетил.

import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/card_list.dart';
import '../widget/sight_card.dart';
import '../widget/small_app_bar.dart';
import '../widget/tab_switch.dart';

class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen>
    with SingleTickerProviderStateMixin {
  static const _visitingScreenTabs = [stringWantToVisit, stringVisited];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: _visitingScreenTabs.length,
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
  Widget build(BuildContext context) => Scaffold(
        appBar: SmallAppBar(
          title: stringFavorite,
          bottom: Padding(
            padding: MyThemeData.commonPaddingLBR,
            child: TabSwitch(
              tabs: _visitingScreenTabs,
              tabController: tabController,
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            Tab(
              child: CardList(
                  cardType: SightCardType.wishlist,
                  iterable:
                      mocks.where((element) => element.visitTime != null)),
            ),
            Tab(
              child: CardList(
                  cardType: SightCardType.visited,
                  iterable: mocks.where((element) => element.visited != null)),
            ),
          ],
        ),
        bottomNavigationBar: const AppNavigationBar(index: 2),
      );
}
