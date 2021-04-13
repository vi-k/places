import 'package:flutter/material.dart';

import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/svg.dart';

import 'loadable_image.dart';
import 'svg_button.dart';

/// Фотокарточка места для галереи.
class PhotoCard extends StatelessWidget {
  const PhotoCard({
    Key? key,
    this.url,
    this.path,
    this.onClose,
  })  : assert(url != null && path == null || url == null && path != null),
        super(key: key);

  /// Url фотографии.
  final String? url;

  /// Путь к фотографии.
  final String? path;

  /// Обратный вызов при закрытии/удалении фотокарточки.
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(photoCardRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            LoadableImage(url: url, path: path),
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
