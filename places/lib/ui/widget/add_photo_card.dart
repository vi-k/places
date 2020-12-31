import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/svg.dart';
import '../res/themes.dart';

class AddPhotoCard extends StatelessWidget {
  const AddPhotoCard({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return SizedBox(
      width: photoCardSize,
      height: photoCardSize,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.accentColor40),
          borderRadius: BorderRadius.circular(textFieldRadius),
        ),
        onPressed: onPressed,
        child: Center(
          child: SvgPicture.asset(
            Svg24.plus,
            width: plusIconSize,
            height: plusIconSize,
            color: theme.accentColor,
          ),
        ),
      ),
    );
  }
}
