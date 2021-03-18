import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app_bloc.dart';

import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/svg.dart';

/// Виджет добавления фотокарточки.
class AddPhotoCard extends StatelessWidget {
  const AddPhotoCard({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  /// Обратный вызов при нажатии.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

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
