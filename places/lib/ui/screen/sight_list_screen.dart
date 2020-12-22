import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../res/strings.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/card_list.dart';
import '../widget/sight_card.dart';
import '../widget/text_app_bar.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const TextAppBar(title: sightListScreenTitle),
        body: CardList(
          cardType: SightCardType.list,
          iterable: mocks.toList()
            ..sort((a, b) => a.coord
                .distance(myMockCoord)
                .compareTo(b.coord.distance(myMockCoord))),
        ),
        bottomNavigationBar: const AppNavigationBar(index: 0),
      );
}
