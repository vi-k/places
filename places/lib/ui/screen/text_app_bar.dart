import 'package:flutter/material.dart';

import '../res/edge_insets.dart';
import '../res/text_styles.dart';

class TextAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TextAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: appBarPadding.add(EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        )),
        child: Text(
          title,
          style: textBold32,
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
