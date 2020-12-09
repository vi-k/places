import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../const.dart';
import 'sight_card.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    // Разбираем заголовок по строкам
    final titleLines = sightListScreenTitle.split('\n');

    return AppBar(
      backgroundColor: screenBackground,
      elevation: 0,
      toolbarHeight: appbarTopSpacing +
          titleLines.length * appbarLineHeight +
          appbarSpacing,
      titleSpacing: appbarSpacing,
      title: Padding(
        padding: const EdgeInsets.only(
          top: appbarTopSpacing,
          bottom: appbarSpacing,
        ),
        child: _buildAppBarTitle(sightListScreenTitle, titleLines.length),
      ),
    );
  }

  Widget _buildAppBarTitle(String title, int linesCount) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: appbarTextStyle,
      maxLines: linesCount,
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        for (final sight in mocks)
          SightCard(
            sight: sight,
          ),
      ],
    );
  }
}
