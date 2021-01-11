import 'package:flutter/material.dart';

import '../res/const.dart';

class SmallLoader extends StatelessWidget {
  const SmallLoader({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: commonSpacing,
        height: commonSpacing,
        child: CircularProgressIndicator(
          valueColor:
              color == null ? null : AlwaysStoppedAnimation<Color>(color!),
          strokeWidth: 2,
        ),
      );
}
