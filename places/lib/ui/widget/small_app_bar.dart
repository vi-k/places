import 'package:flutter/material.dart';

import '../res/strings.dart';
import '../res/themes.dart';
import 'my_theme.dart';
import 'small_button.dart';
import 'svg_button.dart';

/// Виджет: малый AppBar.
class SmallAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SmallAppBar({
    Key? key,
    required this.title,
    this.padding = commonPadding,
    this.back,
    this.button,
    this.onPressed,
    this.bottom,
  })  : assert(onPressed == null || button != null),
        super(key: key);

  /// Заголовок.
  final String title;

  // Отступы вокруг title.
  final EdgeInsetsGeometry padding;

  /// Кнопка слева (по значению всегда возврат, но может иметь разный текст).
  final String? back;

  /// Кнопка справа.
  final String? button;

  /// Реакция на нажатие кнопки справа.
  final void Function()? onPressed;

  /// Виджет снизу AppBar'а.
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              _buildTitle(theme),
              _buildButtons(context, theme),
            ],
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }

  Widget _buildTitle(MyThemeData theme) => Padding(
        padding: padding,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textMiddle18Main2,
          ),
        ),
      );

  Widget _buildButtons(BuildContext context, MyThemeData theme) =>
      Positioned.fill(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (Navigator.canPop(context))
                back == null
                    ? SvgButton(
                        assetBack,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: theme.mainTextColor2,
                      )
                    : SmallButton(
                        label: back!,
                        style: theme.textMiddle16Light,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
              if (button != null)
                SmallButton(
                  style: theme.textMiddle16Accent,
                  label: button!,
                  onPressed: onPressed,
                ),
            ],
          ),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
