import 'package:flutter/material.dart';

import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/svg.dart';

import 'loadable_image.dart';
import 'svg_button.dart';

/// Фотокарточка места для галереи.
class PhotoCard extends StatelessWidget {
  const PhotoCard({
    Key? key,
    required this.url,
    this.onClose,
  }) : super(key: key);

  /// Url фотографии.
  final String url;

  /// Обратный вызов при закрытии/удалении фотокарточки.
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    borderRadius: BorderRadius.circular(textFieldRadius),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        LoadableImage(url: url),
        if (onClose != null)
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment.topRight,
                child: SvgButton(
                  Svg24.clear,
                  iconSize: clearIconSize,
                  width: clearButtonSize,
                  height: clearButtonSize,
                  color: mainColor100,
                  highlightColor: highlightColorDark2,
                  splashColor: splashColorDark2,
                  onPressed: onClose,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
