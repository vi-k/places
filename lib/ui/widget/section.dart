import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/ui/res/const.dart';

/// Раздел.
///
/// Состоит из названия раздела и виджета-ребёнка.
///
/// Отступы задаются через [top], [left] и [right], расстояние от названия
/// раздела до содержимого через [spacing]. [applyPaddingToChild] нужен, чтобы
/// применить эти же отступы к содержимому раздела.
class Section extends StatelessWidget {
  Section(
    this.name, {
    required this.child,
    double top = sectionTop,
    double left = commonSpacing,
    double right = commonSpacing,
    double spacing = commonSpacing3_4,
    bool applyPaddingToChild = true,
  })  : namePadding = EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: spacing,
        ),
        childPadding = applyPaddingToChild
            ? EdgeInsets.only(left: left, right: right)
            : EdgeInsets.zero;

  /// Название раздела.
  final String name;

  /// Содержимое раздела.
  final Widget child;

  /// Отступы.
  ///
  /// Вычисляемые поля, устанавливаемые по переданным [top], [left], [right],
  /// [spacing] и [applyPaddingToChild].
  final EdgeInsets namePadding;
  final EdgeInsets childPadding;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: namePadding,
          child: Text(
            name.toUpperCase(),
            style: theme.textRegular12Light56,
          ),
        ),
        Padding(
          padding: childPadding,
          child: child,
        ),
      ],
    );
  }
}
