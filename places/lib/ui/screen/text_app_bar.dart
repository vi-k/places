import 'package:flutter/material.dart';

import '../res/const.dart';
import '../res/text_styles.dart';

class TextAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TextAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: appbarSpacing,
          top: MediaQuery.of(context).padding.top + appbarTopSpacing,
          right: appbarSpacing,
          bottom: appbarSpacing,
        ),
        child: Text(
          title,
          style: appbarTextStyle,
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
