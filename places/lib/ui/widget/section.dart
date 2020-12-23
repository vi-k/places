/// Виджет: Раздел.
///
/// Состоит из названия раздела и виджета-ребёнка.

import 'package:flutter/material.dart';

import '../res/themes.dart';
import 'my_theme.dart';

class Section extends StatelessWidget {
  Section(
    this.name, {
    required this.child,
    double top = MyThemeData.sectionTop,
    double left = MyThemeData.sectionHSpacing,
    double right = MyThemeData.sectionHSpacing,
    double spacing = MyThemeData.sectionVSpacing,
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
