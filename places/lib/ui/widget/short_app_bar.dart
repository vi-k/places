import 'package:flutter/material.dart';

import '../res/themes.dart';

class ShortAppBar extends StatelessWidget implements PreferredSizeWidget {
  ShortAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.bottom,
    EdgeInsetsGeometry? padding,
  })  : assert(title != null && titleWidget == null ||
            title == null && titleWidget != null),
        padding = padding ?? MyThemeData.shortAppBarPadding,
        super(key: key);

  final String? title;
  final Widget? titleWidget;
  final Widget? bottom;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding.add(EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleWidget ??
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.headline3,
                ),
            if (bottom != null) ...[
              const SizedBox(height: MyThemeData.shortAppBarSpacing),
              bottom!,
            ]
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
