import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/themes.dart';

/// Стандартная универсальная кнопка.
///
/// Иконка, если нужна, берётся из ресурсов по имени, переданному в параметре
/// [svg]. Текст кнопки передаётся в строке [label].
class StandartButton extends StatelessWidget {
  const StandartButton({
    Key? key,
    this.color,
    this.svg,
    required this.label,
    this.style,
    required this.onPressed,
  }) : super(key: key);

  /// Цвет кнопки.
  final Color? color;

  /// Идентификатор ресурса (ассет) для SVG.
  final String? svg;

  /// Текст кнопки.
  final String label;

  /// Стиль текста кнопки.
  final TextStyle? style;

  /// Обратный вызов при нажатии.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final textStyle = style ?? theme.textMiddle14White;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: standartButtonHeight),
      child: svg == null
          ? RaisedButton(
              color: color,
              onPressed: onPressed,
              child: Text(
                label.toUpperCase(),
                style: textStyle,
              ),
            )
          : RaisedButton.icon(
              color: color,
              onPressed: onPressed,
              icon: SvgPicture.asset(
                svg!,
                color: textStyle.color,
              ),
              label: Text(
                label.toUpperCase(),
                style: textStyle,
              ),
            ),
    );
  }
}
