import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/themes.dart';

/// Виджет: Стандартная универсальная кнопка.
///
/// Иконка, если нужна, берётся из ресурсов по имени, переданному в параметре
/// [svg]. Текст кнопки передаётся в строке [label].
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
    final theme = MyTheme.of(context);
    final textStyle = theme.textBold14White;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: standartButtonHeight),
      child: svg == null
          ? RaisedButton(
              onPressed: onPressed,
              child: Text(
                label.toUpperCase(),
                style: textStyle,
              ),
            )
          : RaisedButton.icon(
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
