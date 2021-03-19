import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app_bloc.dart';

import 'package:places/ui/res/const.dart';

/// Малая кнопка.
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

  /// Размеры, если нужны.
  final double? width;
  final double? height;

  /// Цвет, если нужен. По умолчанию прозрачный.
  final Color? color;

  /// Цвета для Ripple-эффекта.
  ///
  /// По умолчанию `Theme.highlightColor` и `Theme.splashColor`.
  final Color? highlightColor;
  final Color? splashColor;

  /// Стиль текста.
  ///
  /// По умолчанию `MyTheme.textRegular14Main` или
  /// `MyTheme.textRegular14Light56`, если [onPressed] не задан.
  final TextStyle? style;

  /// Иконка для кнопки или идентификатор ресурса (ассет) для SVG.
  final Widget? icon;
  final String? svg;

  /// Подпись.
  final String label;

  /// Обратный вызов при нажатии.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;
    final textStyle = style ??
        (onPressed != null
            ? theme.textRegular14Main
            : theme.textRegular14Light56);

    return SizedBox(
      width: width,
      height: height,
      child: svg == null && icon == null
          ? TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color),
              ),
              onPressed: onPressed,
              child: Text(
                label,
                style: textStyle,
              ),
            )
          : TextButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color),
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
