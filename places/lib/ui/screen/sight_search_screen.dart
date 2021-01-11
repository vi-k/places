import 'package:flutter/material.dart';

import '../res/const.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/search_bar.dart';
import '../widget/section.dart';
import '../widget/small_app_bar.dart';

/// Экран поиска.
///
/// TODO: реализовать поиск.
class SightSearchScreen extends StatefulWidget {
  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: const SmallAppBar(
        title: stringSightList,
        bottom: Padding(
          padding: commonPadding,
          child: SearchBar(),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Section(
            stringLookingFor,
            child: const SizedBox(),
          ),
          Expanded(
            child: ListView(
              children: const [],
            ),
          ),
        ],
      ),
    );
  }
}
