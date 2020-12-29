import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/themes.dart';
import 'my_theme.dart';

/// Виджет: Кнопка-иконка для svg.
class SvgButton extends StatelessWidget {
  SvgButton(
    this.svg, {
    Key? key,
    this.iconSize = 24,
    this.width = smallButtonHeight,
    this.height = smallButtonHeight,
    this.color,
    this.highlightColor,
    this.splashColor,
    this.onPressed,
  })  : padding = EdgeInsets.symmetric(
          horizontal: (width - iconSize) / 2,
          vertical: (height - iconSize) / 2,
        ),
        super(key: key);

  final String svg;
  final double iconSize;
  final double width;
  final double height;
  late final EdgeInsets padding;
  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return IconButton(
      constraints: const BoxConstraints(),
      iconSize: iconSize,
      padding: padding,
      highlightColor: highlightColor ?? theme.app.highlightColor,
      splashColor: splashColor ?? theme.app.splashColor,
      onPressed: onPressed,
      icon: SvgPicture.asset(
        svg,
        color: color,
      ),
    );
  }
}
