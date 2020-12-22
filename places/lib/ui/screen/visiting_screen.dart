import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/card_list.dart';
import '../widget/short_app_bar.dart';
import '../widget/sight_card.dart';
import '../widget/tab_switch.dart';

class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: visitingScreenTabs.length,
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
        appBar: ShortAppBar(
          title: visitingScreenTitle,
          bottom: Padding(
            padding: MyThemeData.commonPaddingToTop,
            child: TabSwitch(
              tabs: visitingScreenTabs,
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
