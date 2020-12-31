import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/themes.dart';

/// Виджет: Малая кнопка.
///
/// Обычно для текстовых кнопок, не имеющих фона.
class SmallButton extends StatelessWidget {
  const SmallButton({
    Key? key,
    this.width,
    this.height = smallButtonHeight,
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

  final double? width;
  final double? height;
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
            : theme.textRegular14Light56);

    return SizedBox(
      width: width,
      height: height,
      child: svg == null && icon == null
          ? FlatButton(
              color: color,
              highlightColor: highlightColor ?? theme.app.highlightColor,
              splashColor: splashColor ?? theme.app.splashColor,
              height: smallButtonHeight,
              minWidth: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(smallButtonRadius),
              ),
              onPressed: onPressed,
              child: Text(
                label,
                style: textStyle,
              ),
            )
          : FlatButton.icon(
              color: color ?? Colors.transparent,
              highlightColor: highlightColor ?? theme.app.highlightColor,
              splashColor: splashColor ?? theme.app.splashColor,
              height: smallButtonHeight,
              minWidth: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(smallButtonRadius),
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
