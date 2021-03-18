import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app_bloc.dart';

import 'package:places/ui/res/const.dart';
import 'package:places/utils/let_and_also.dart';

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
    final theme = context.watch<AppBloc>().theme;
    final textStyle = style ?? theme.textMiddle14White;
    final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(color),
    );
    final text = Text(label.toUpperCase(), style: textStyle);

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: standartButtonHeight),
      child: svg?.let((it) => ElevatedButton.icon(
                style: buttonStyle,
                onPressed: onPressed,
                icon: SvgPicture.asset(it, color: textStyle.color),
                label: text,
              )) ??
          ElevatedButton(
            style: buttonStyle,
            onPressed: onPressed,
            child: text,
          ),
    );
  }
}
