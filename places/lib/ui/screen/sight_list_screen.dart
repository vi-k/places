import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../res/colors.dart';
import '../res/strings.dart';
import '../widget/card_list.dart';
import '../widget/text_app_bar.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: screenBackground,
        appBar: const TextAppBar(title: sightListScreenTitle),
        body: CardList(
          iterable: mocks,
        ),
      );
}
