import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/themes.dart';

/// Виджет: Кнопка-иконка для svg.
class SvgButton extends StatelessWidget {
  const SvgButton(
    this.svg, {
    Key? key,
    this.iconSize = deafultIconSize,
    this.width = smallButtonHeight,
    this.height = smallButtonHeight,
    this.color,
    this.highlightColor,
    this.splashColor,
    this.onPressed,
  }) : super(key: key);

  final String svg;
  final double iconSize;
  final double width;
  final double height;
  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(width: width, height: height),
      highlightColor: highlightColor ?? theme.app.highlightColor,
      splashColor: splashColor ?? theme.app.splashColor,
      onPressed: onPressed,
      icon: SvgPicture.asset(
        svg,
        width: iconSize,
        height: iconSize,
        color: color,
      ),
    );
  }
}
