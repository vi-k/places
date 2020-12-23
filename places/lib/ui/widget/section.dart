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
    EdgeInsetsGeometry? padding,
  }) : padding = padding ?? MyThemeData.commonPaddingToTop;

  final String name;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: MyThemeData.sectionPadding,
          child: Text(
            name.toUpperCase(),
            style: theme.textRegular12Light56,
          ),
        ),
        Padding(
          padding: padding,
          child: child,
        ),
      ],
    );
  }
}
