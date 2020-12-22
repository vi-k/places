import 'package:flutter/material.dart';

import '../res/strings.dart';
import '../res/themes.dart';
import 'my_theme.dart';
import 'small_button.dart';
import 'svg_button.dart';

class ShortAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShortAppBar({
    Key? key,
    required this.title,
    this.back,
    this.button,
    this.onPressed,
    this.bottom,
    EdgeInsetsGeometry? padding,
  })  : assert(onPressed == null || button != null),
        padding = padding ?? MyThemeData.shortAppBarPadding,
        super(key: key);

  final String title;
  final String? back;
  final String? button;
  final void Function()? onPressed;
  final Widget? bottom;
  final EdgeInsetsGeometry padding;

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
            style: theme.textMiddle18Main,
          ),
        ),
      );

  Positioned _buildButtons(BuildContext context, MyThemeData theme) =>
      Positioned.fill(
        child: Material(
          // Для IconButton, если у AppBar'а будет цвет
          type: MaterialType.transparency,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (Navigator.canPop(context))
                  back == null
                      ? SvgButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          svg: assetBack,
                          color: theme.mainTextColor2,
                        )
                      : SmallButton(
                          label: back!,
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
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
