import 'package:flutter/material.dart';

import '../res/const.dart';
import '../res/edge_insets.dart';

class ShortAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShortAppBar({
    Key? key,
    required this.title,
    this.bottom,
  }) : super(key: key);

  final String title;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) => Padding(
        padding: shortAppBarPadding.add(EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.headline3,
            ),
            if (bottom != null) const SizedBox(height: shortAppBarSpacing),
            if (bottom != null) bottom!,
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(400);
}
