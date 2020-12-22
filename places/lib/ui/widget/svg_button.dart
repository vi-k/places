import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/themes.dart';
import 'my_theme.dart';

class SvgButton extends StatelessWidget {
  const SvgButton({
    Key? key,
    required this.svg,
    this.color,
    this.highlightColor,
    this.splashColor,
    this.onPressed,
  }) : super(key: key);

  final String svg;
  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return SizedBox(
      height: MyThemeData.smallButtonHeight,
      width: MyThemeData.smallButtonHeight,
      child: IconButton(
        highlightColor: highlightColor ?? theme.tapHighlightColor,
        splashColor: splashColor ?? theme.tapSplashColor,
        onPressed: onPressed,
        icon: SvgPicture.asset(
          svg,
          color: color,
        ),
      ),
    );
  }
}
