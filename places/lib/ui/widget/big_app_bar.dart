/// Виджет: большой AppBar (для страницы списка интересных мест).

import 'package:flutter/material.dart';

import '../res/themes.dart';
import 'my_theme.dart';

class BigAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BigAppBar({
    Key? key,
    required this.title,
    this.bottom,
  }) : super(key: key);

  /// Заголовок.
  final String title;

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
          Padding(
            padding: MyThemeData.appBarPadding,
            child: Text(title, style: theme.textBold32Main),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
