import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../res/strings.dart';
import '../widget/card_list.dart';
import '../widget/short_app_bar.dart';
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
  Widget build(BuildContext context) => DefaultTabController(
        length: visitingScreenTabs.length,
        child: Scaffold(
          appBar: ShortAppBar(
            title: visitingScreenTitle,
            bottom: TabSwitch(
              tabs: visitingScreenTabs,
              tabController: tabController,
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Tab(
                child: CardList(
                    iterable:
                        mocks.where((element) => element.visitTime != null)),
              ),
              Tab(
                child: CardList(
                    iterable:
                        mocks.where((element) => element.visited != null)),
              ),
            ],
          ),
        ),
      );
}
