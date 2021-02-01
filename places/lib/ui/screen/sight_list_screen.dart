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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTitleDelegate(
              systemBarHeight: MediaQuery.of(context).padding.top,
              bigTitleStyle: theme.textBold32Main,
              smallTitleStyle: theme.textMiddle18Main2,
              onlySmall: !isPortrait,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3 / 2,
              crossAxisCount: isPortrait ? 1 : 2,
            ),
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
      floatingActionButton: isPortrait
          ? FloatingActionButton.extended(
              isExtended: true,
              onPressed: () => Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SightEditScreen(),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text(stringNewPlace.toUpperCase()),
            )
          : FloatingActionButton(
              onPressed: () => Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SightEditScreen(),
                ),
              ),
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: const AppNavigationBar(index: 0),
    );
  }
}

/// Делегат для изображения заголовка, изменяющегося в размерах так, как нам
/// надо.
class _SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  _SliverTitleDelegate({
    required this.systemBarHeight,
    required this.bigTitleStyle,
    required this.smallTitleStyle,
    required this.onlySmall,
  })   : bigTitleHeight = bigTitleStyle.fontSize! * bigTitleStyle.height!,
        smallTitleHeight = smallTitleStyle.fontSize! * smallTitleStyle.height!;

  /// Высота системного бара.
  ///
  /// Нужна в maxExtent и minExtent, где недоступен context. Чтобы не создавать
  /// костыли, просто требуем значение от того, кто вызывает.
  final double systemBarHeight;

  /// Высота максимального заголовка. Вычисляемое значение.
  final double bigTitleHeight;

  /// Стиль текста при максимальном размере заголовка.
  final TextStyle bigTitleStyle;

  /// Высота минимального заголовка. Вычисляемое значение.
  final double smallTitleHeight;

  /// Стиль текста при минимальном размере заголовка.
  final TextStyle smallTitleStyle;

  /// Не используется анимация перехода. Заголовок всегда минимальный.
  final bool onlySmall;

  /// Смещение текста заголовка при максимальном заголовке.
  static const bigTitleOffset = 40;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = MyTheme.of(context);
    final maxHeight = maxExtent;
    final minHeight = minExtent;
    final flexibleSpace = maxHeight - minHeight;
    final k = shrinkOffset >= flexibleSpace
        ? 0.0
        : (flexibleSpace - shrinkOffset) / flexibleSpace;

    return Material(
      color: theme.backgroundFirst,
      elevation: shrinkOffset > flexibleSpace ? 4 : 0,
      child: Padding(
        padding: commonPadding,
        child: Column(
          children: [
            SizedBox(
              height: systemBarHeight + k * bigTitleOffset,
            ),
            Align(
              alignment: Alignment(-k, 0),
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
              onTap: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (context) => SightSearchScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => onlySmall
      ? minExtent
      : systemBarHeight +
          bigTitleOffset +
          commonSpacing +
          2 * bigTitleHeight +
          commonSpacing +
          smallButtonHeight +
          commonSpacing;

  @override
  double get minExtent =>
      systemBarHeight +
      commonSpacing +
      smallTitleHeight +
      commonSpacing +
      smallButtonHeight +
      commonSpacing;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
