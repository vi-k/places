import 'package:flutter/material.dart';

import '../res/const.dart';
import '../res/themes.dart';

/// Виджет: Раздел.
///
/// Состоит из названия раздела и виджета-ребёнка.
class Section extends StatelessWidget {
  Section(
    this.name, {
    required this.child,
    double top = sectionTop,
    double left = commonSpacing,
    double right = commonSpacing,
    double spacing = commonSpacing3_4,
    bool applyPaddingToChild = true,
  })  : namePadding = EdgeInsets.only(
            left: left, top: top, right: right, bottom: spacing),
        childPadding = applyPaddingToChild
            ? EdgeInsets.only(left: left, right: right)
            : EdgeInsets.zero;

  final String name;
  final Widget child;
  final EdgeInsets namePadding;
  final EdgeInsets childPadding;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: namePadding,
          child: Text(
            name.toUpperCase(),
            style: theme.textRegular12Light56,
          ),
        ),
        Padding(
          padding: childPadding,
          child: child,
        ),
      ],
    );
  }
}
