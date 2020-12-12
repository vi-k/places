import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../res/colors.dart';
import '../res/edge_insets.dart';
import '../res/strings.dart';
import 'sight_card.dart';
import 'text_app_bar.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: screenBackground,
        appBar: const TextAppBar(title: sightListScreenTitle),
        body: ListView.separated(
          padding: listPadding,
          itemCount: mocks.length,
          itemBuilder: (context, index) => SightCard(
            sight: mocks[index],
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
        ),
      );
}
