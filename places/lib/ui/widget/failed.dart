import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import 'small_button.dart';

/// Виджет ошибки.
class Failed extends StatelessWidget {
  const Failed(
    this.error, {
    Key? key,
    this.onRepeat,
  }) : super(key: key);

  /// Текст ошибки.
  final String error;

  /// Обратный вызов, если есть желание и возможность повторить операцию,
  /// приведшую к ошибке.
  /// 
  /// Если не `null`, будет добавлена кнопка для повторения.
  final void Function()? onRepeat;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Center(
      child: Padding(
        padding: commonPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Svg64.delete, color: theme.lightTextColor56),
            const SizedBox(height: commonSpacing3_2),
            Text(stringError, style: theme.textMiddle18Light56),
            const SizedBox(height: commonSpacing1_2),
            Text(error, style: theme.textRegular14Light56),
            if (onRepeat != null)
              SmallButton(
                label: stringRepeat,
                style: theme.textMiddle16Accent,
                onPressed: onRepeat,
              ),
          ],
        ),
      ),
    );
  }
}
