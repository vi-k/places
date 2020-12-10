import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../res/colors.dart';
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
        body: ListView(
          children: [
            for (final sight in mocks)
              SightCard(
                sight: sight,
              ),
          ],
        ),
      );

  // PreferredSizeWidget _buildAppBar() {
  //   // Разбираем заголовок по строкам
  //   final titleLines = sightListScreenTitle.split('\n');

  //   return AppBar(
  //     backgroundColor: screenBackground,
  //     elevation: 0,
  //     toolbarHeight: appbarTopSpacing +
  //         titleLines.length * appbarLineHeight +
  //         appbarSpacing,
  //     titleSpacing: appbarSpacing,
  //     title: Padding(
  //       padding: const EdgeInsets.only(
  //         top: appbarTopSpacing,
  //         bottom: appbarSpacing,
  //       ),
  //       child: _buildAppBarTitle(sightListScreenTitle, titleLines.length),
  //     ),
  //   );
  // }

  // Widget _buildAppBarTitle(String title, int linesCount) {
  //   return Text(
  //     title,
  //     overflow: TextOverflow.ellipsis,
  //     style: appbarTextStyle,
  //     maxLines: linesCount,
  //   );
  // }

  // Widget _buildBody() => ListView(
  //       children: [
  //         for (final sight in mocks)
  //           SightCard(
  //             sight: sight,
  //           ),
  //       ],
  //     );
}
