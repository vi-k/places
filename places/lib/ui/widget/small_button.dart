import 'package:flutter/material.dart';

import '../res/const.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    Key? key,
    this.color = Colors.transparent,
    this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final Widget? icon;
  final Widget label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => icon == null
      ? FlatButton(
          color: color,
          highlightColor: color == Colors.transparent
              ? null
              : Colors.white.withOpacity(0.1),
          splashColor: color == Colors.transparent
              ? null
              : Colors.white.withOpacity(0.1),
          height: smallButtonHeight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallButtonRadius),
          ),
          onPressed: onPressed,
          child: label,
        )
      : FlatButton.icon(
          color: color,
          height: standartButtonHeight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallButtonRadius),
          ),
          onPressed: onPressed,
          icon: icon!,
          label: label,
        );
}
