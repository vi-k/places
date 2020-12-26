import 'package:flutter/material.dart';

import '../res/themes.dart';
import 'loadable_image.dart';
import 'my_theme.dart';

/// Виджет: фотокарточка для создания нового места.
class PhotoCard extends StatelessWidget {
  const PhotoCard({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return SizedBox(
      width: photoCardSize,
      height: photoCardSize,
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(textFieldRadius),
        clipBehavior: Clip.antiAlias,
        child: LoadableImage(url: url),
      ),
    );
  }
}
