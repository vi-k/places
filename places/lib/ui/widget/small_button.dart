import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import 'my_theme.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    Key? key,
    this.color,
    this.style,
    this.svg,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  final Color? color;
  final TextStyle? style;
  final String? svg;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        (onPressed != null
            ? MyTheme.of(context).flatButtonTextStyle
            : MyTheme.of(context).flatButtonInactiveTextStyle);

    return svg == null
        ? FlatButton(
            color: color,
            // highlightColor: color == Colors.transparent
            //     ? null
            //     : Colors.white.withOpacity(0.1),
            // splashColor: color == Colors.transparent
            //     ? null
            //     : Colors.white.withOpacity(0.1),
            height: smallButtonHeight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(smallButtonRadius),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: textStyle,
            ),
          )
        : FlatButton.icon(
            color: color ?? Colors.transparent,
            height: smallButtonHeight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(smallButtonRadius),
            ),
            onPressed: onPressed,// ?? () {},
            icon: SvgPicture.asset(
              svg!,
              color: textStyle.color,
            ),
            label: Text(
              label,
              style: textStyle,
            ),
          );
  }
}
