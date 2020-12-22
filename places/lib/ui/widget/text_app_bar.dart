import 'package:flutter/material.dart';

import '../res/themes.dart';

class TextAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TextAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: MyThemeData.appBarPadding.add(EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        )),
        child: Text(
          title,
          style: Theme.of(context).primaryTextTheme.headline1,
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
