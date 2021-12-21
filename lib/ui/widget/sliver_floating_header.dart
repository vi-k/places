import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/ui/res/const.dart';

class SliverFloatingHeader extends StatelessWidget {
  const SliverFloatingHeader({
    Key? key,
    required this.title,
    this.onlySmall = false,
    this.bottom,
    this.bottomHeight = 0,
  }) : super(key: key);

  final String title;
  final bool onlySmall;

  /// Виджет снизу.
  final Widget? bottom;
  final double bottomHeight;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: SliverTitleDelegate(
        systemBarHeight: MediaQuery.of(context).padding.top,
        title: title,
        bigTitleStyle: theme.textBold32Main,
        smallTitleStyle: theme.textMiddle18Main2,
        onlySmall: onlySmall,
        bottom: bottom,
        bottomHeight: bottomHeight,
      ),
    );
  }
}

/// Делегат для изображения заголовка, изменяющегося в размерах так, как нам
/// надо.
class SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  SliverTitleDelegate({
    required this.systemBarHeight,
    required this.title,
    required this.bigTitleStyle,
    required this.smallTitleStyle,
    required this.onlySmall,
    this.bottom,
    this.bottomHeight = 0,
  })  : bigTitleHeight = bigTitleStyle.fontSize! * bigTitleStyle.height!,
        smallTitleHeight = smallTitleStyle.fontSize! * smallTitleStyle.height!,
        assert(bottom == null || bottomHeight != 0);

  /// Высота системного бара.
  ///
  /// Нужна в maxExtent и minExtent, где недоступен context. Чтобы не создавать
  /// костыли, просто требуем значение от того, кто вызывает.
  final double systemBarHeight;

  /// Заголовок.
  final String title;

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

  /// Виджет снизу.
  final Widget? bottom;
  final double bottomHeight;

  /// Смещение текста заголовка при максимальном заголовке.
  static const bigTitleOffset = 40;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = context.watch<AppBloc>().theme;
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
                  title,
                  style: TextStyle.lerp(smallTitleStyle, bigTitleStyle, k),
                ),
              ),
            ),
            const SizedBox(height: commonSpacing),
            if (bottom != null) bottom!,
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
          (bottom == null ? 0 : bottomHeight + commonSpacing);

  @override
  double get minExtent =>
      systemBarHeight +
      commonSpacing +
      smallTitleHeight +
      commonSpacing +
      (bottom == null ? 0 : bottomHeight + commonSpacing);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
