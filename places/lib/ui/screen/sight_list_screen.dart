/// Экран: Список интересных мест.

import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../res/strings.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/big_app_bar.dart';
import '../widget/card_list.dart';
import '../widget/sight_card.dart';
import 'add_sight_screen.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const BigAppBar(title: stringSightListTitle),
        body: CardList(
          cardType: SightCardType.list,
          iterable: mocks.toList()
            ..sort((a, b) => a.coord
                .distance(myMockCoord)
                .compareTo(b.coord.distance(myMockCoord))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          isExtended: true,
          onPressed: () {
            // Navigator.pushReplacement<void, void>(
            Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSightScreen(),
                ));
          },
          icon: const Icon(Icons.add),
          label: Text(stringNewPlace.toUpperCase()),
        ),
        bottomNavigationBar: const AppNavigationBar(index: 0),
      );
}
