/// Виджет: большой AppBar (для страницы списка интересных мест).

import 'package:flutter/material.dart';

import '../res/themes.dart';
import 'my_theme.dart';

class BigAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BigAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Padding(
      padding: MyThemeData.appBarPadding.add(EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      )),
      child: Text(title, style: theme.textBold32Main),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
