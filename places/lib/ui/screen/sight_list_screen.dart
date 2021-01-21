import 'package:flutter/material.dart';

import '../../domain/mocks_data.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/mocks.dart';
import '../widget/search_bar.dart';
import '../widget/sight_card.dart';
import 'sight_edit_screen.dart';
import 'sight_search_screen.dart';

/// Экран "Список интересных мест".
class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    // Временное решение. В нормальном случае надо будет из репозитория
    // получать готовый список через Future.
    final sights = Mocks.of(context, listen: true).sights
      ..sort((a, b) => a.coord
          .distance(myMockCoord)
          .compareTo(b.coord.distance(myMockCoord)));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTitleDelegate(
              systemBarHeight: MediaQuery.of(context).padding.top,
              bigTitleStyle: theme.textBold32Main,
              smallTitleStyle: theme.textMiddle18Main2,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: commonPaddingLBR,
                child: SightCard(
                  sightId: sights[index].id,
                  type: SightCardType.list,
                ),
              ),
              childCount: sights.length,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: () {
          Navigator.push<int>(
            context,
            MaterialPageRoute(
              builder: (context) => const SightEditScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(stringNewPlace.toUpperCase()),
      ),
      bottomNavigationBar: const AppNavigationBar(index: 0),
    );
  }
}

class _SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  _SliverTitleDelegate({
    required this.systemBarHeight,
    required this.bigTitleStyle,
    required this.smallTitleStyle,
  })   : bigTitleHeight = bigTitleStyle.fontSize! * bigTitleStyle.height!,
        smallTitleHeight = smallTitleStyle.fontSize! * smallTitleStyle.height!;

  final double systemBarHeight;
  final TextStyle bigTitleStyle;
  final TextStyle smallTitleStyle;
  final double bigTitleHeight;
  final double smallTitleHeight;

  static const bigTitleOffset = 40;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = MyTheme.of(context);
    final flexibleSpace = bigTitleOffset + bigTitleHeight;
    final k = shrinkOffset >= flexibleSpace
        ? 0.0
        : (flexibleSpace - shrinkOffset) / flexibleSpace;

    return Container(
      color: theme.backgroundFirst,
      padding: commonPadding,
      child: Column(
        children: [
          SizedBox(
            height: systemBarHeight + k * bigTitleOffset,
          ),
          Align(
            alignment: Alignment(k == 1.0 ? -1 : 0, 0),
            child: SizedBox(
              height: smallTitleHeight +
                  (2 * bigTitleHeight - smallTitleHeight) * k,
              child: Text(
                stringSightList,
                style: TextStyle.lerp(smallTitleStyle, bigTitleStyle, k),
              ),
            ),
          ),
          const SizedBox(height: commonSpacing),
          SearchBar(
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => SightSearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent =>
      systemBarHeight +
      bigTitleOffset +
      commonSpacing +
      2 * bigTitleHeight +
      commonSpacing +
      smallButtonHeight +
      commonSpacing;

  @override
  double get minExtent => systemBarHeight +
      commonSpacing +
      smallTitleHeight +
      commonSpacing +
      smallButtonHeight +
      commonSpacing;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
