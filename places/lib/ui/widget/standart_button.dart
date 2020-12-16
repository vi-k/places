import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/colors.dart';
import '../res/const.dart';

class StandartButton extends StatelessWidget {
  const StandartButton({
    Key? key,
    this.svg,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String? svg;
  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).accentTextTheme.headline4;

    return svg == null
      ? RaisedButton(
          color: Theme.of(context).buttonTheme.colorScheme?.primary,
          onPressed: onPressed,
          child: Text(
            label,
            style: textStyle,
          ),
        )
      : RaisedButton.icon(
          onPressed: onPressed,
          icon: SvgPicture.asset(
            svg!,
            color: textStyle?.color,
          ),
          label: Text(
            label,
            style: textStyle,
          ),
        );
  }
}
