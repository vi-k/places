import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';

import 'small_button.dart';

/// Виджет ошибки.
class Failed extends StatelessWidget {
  const Failed({
    Key? key,
    this.svg = Svg64.delete,
    this.title = stringError,
    required this.message,
    this.onRepeat,
  }) : super(key: key);

  /// Иконка.
  final String svg;

  /// Заголовок.
  final String title;

  /// Сообщение.
  final String message;

  /// Обратный вызов, если есть желание и возможность повторить операцию,
  /// приведшую к ошибке.
  ///
  /// Если не `null`, будет добавлена кнопка для повторения.
  final void Function()? onRepeat;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svg,
            color: theme.lightTextColor56,
          ),
          const SizedBox(height: commonSpacing3_2),
          Text(
            title,
            style: theme.textMiddle18Light56,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: commonSpacing1_2),
          Text(
            message,
            style: theme.textRegular14Light56,
            textAlign: TextAlign.center,
          ),
          if (onRepeat != null)
            SmallButton(
              label: stringRepeat,
              style: theme.textMiddle16Accent,
              onPressed: onRepeat,
            ),
        ],
      ),
    );
  }
}
