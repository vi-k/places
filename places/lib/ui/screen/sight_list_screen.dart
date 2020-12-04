import 'package:flutter/material.dart';

import '../const.dart';

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
        child: _buildAppBarTitle(titleLines),
      ),
    );
  }

  Widget _buildAppBarTitle(List<String> titleLines) {
    assert(titleLines.isNotEmpty);

    final firstLine = titleLines[0];
    final remainingLines = titleLines.skip(1);

    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: firstLine.substring(0, 1),
        style: const TextStyle(
          color: appbarFirstLineInitialLetterColor,
          fontSize: appbarFontSize,
          height: appbarLineMultiplier,
          fontWeight: appbarFontWeight,
        ),
        children: [
          TextSpan(
            text: firstLine.substring(1),
            style: const TextStyle(
              color: appbarFontColor,
            ),
          ),
          for (final line in remainingLines)
            TextSpan(
                text: '\n${line.substring(0, 1)}',
                style: const TextStyle(
                  color: appbarSecondLineInitialLetterColor,
                ),
                children: [
                  TextSpan(
                    text: line.substring(1),
                    style: const TextStyle(
                      color: appbarFontColor,
                    ),
                  ),
                ]),
        ],
      ),
      maxLines: titleLines.length,
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCard('Card 1'),
        _buildCard('Card 2'),
      ],
    );
  }

  Widget _buildCard(String text) {
    return Card(
      margin: cardMargin,
      child: Container(
        padding: cardPadding,
        height: cardHeight,
        color: cardBackground,
        child: Text(text),
      ),
    );
  }
}
