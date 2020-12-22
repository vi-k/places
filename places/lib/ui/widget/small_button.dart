import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/themes.dart';
import 'my_theme.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    Key? key,
    this.color,
    this.highlightColor,
    this.splashColor,
    this.style,
    this.svg,
    this.icon,
    required this.label,
    this.onPressed,
  })  : assert(svg == null || icon == null),
        super(key: key);

  final Color? color;
  final Color? highlightColor;
  final Color? splashColor;
  final TextStyle? style;
  final String? svg;
  final Widget? icon;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final textStyle = style ??
        (onPressed != null
            ? theme.textRegular14Main
            : theme.textRegular16Light56);

    return SizedBox(
      height: MyThemeData.smallButtonHeight,
      child: svg == null && icon == null
          ? FlatButton(
              color: color,
              highlightColor: highlightColor,
              splashColor: splashColor,
              height: MyThemeData.smallButtonHeight,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(MyThemeData.smallButtonRadius),
              ),
              onPressed: onPressed,
              child: Text(
                label,
                style: textStyle,
              ),
            )
          : FlatButton.icon(
              color: color ?? Colors.transparent,
              highlightColor: highlightColor,
              splashColor: splashColor,
              height: MyThemeData.smallButtonHeight,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(MyThemeData.smallButtonRadius),
              ),
              onPressed: onPressed,
              icon: icon ??
                  SvgPicture.asset(
                    svg!,
                    color: textStyle.color,
                  ),
              label: Text(
                label,
                style: textStyle,
              ),
            ),
    );
  }
}
