import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/themes.dart';

class SvgButton extends StatelessWidget {
  const SvgButton({
    Key? key,
    required this.svg,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final String svg;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MyThemeData.smallButtonHeight,
        width: MyThemeData.smallButtonHeight,
        child: IconButton(
          highlightColor: MyThemeData.tapOnImageHighlightColor,
          splashColor: MyThemeData.tapOnImageHighlightColor,
          onPressed: onPressed,
          icon: SvgPicture.asset(
            svg,
            color: color,
          ),
        ),
      );
}
