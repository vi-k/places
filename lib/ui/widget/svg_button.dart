import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';

import 'package:places/ui/res/const.dart';

/// Кнопка-иконка для svg.
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

  /// Идентификатор ресурса (ассет) для SVG.
  final String svg;

  /// Размер иконки. По умолчанию [deafultIconSize].
  final double iconSize;

  /// Размеры кнопки. По умолчанию оба [smallButtonHeight].
  final double width;
  final double height;

  /// Цвет кнопки, если нужен.
  final Color? color;

  /// Цвета для Ripple-эффекта.
  ///
  /// По умолчанию `Theme.highlightColor` и `Theme.splashColor`.
  final Color? highlightColor;
  final Color? splashColor;

  /// Обратный вызов при нажатии.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return IconButton(
      padding: EdgeInsets.zero,
      color: Colors.blue,
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
