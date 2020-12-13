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
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => icon == null
      ? FlatButton(
          onPressed: onPressed,
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
          child: label,
        )
      : FlatButton.icon(
          onPressed: onPressed,
          color: color,
          height: standartButtonHeight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallButtonRadius),
          ),
          icon: icon!,
          label: label,
        );
}
