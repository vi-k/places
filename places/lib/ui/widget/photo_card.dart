import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/svg.dart';
import 'loadable_image.dart';

/// Виджет: фотокарточка для создания нового места.
class PhotoCard extends StatelessWidget {
  const PhotoCard({
    Key? key,
    required this.url,
    required this.onClose,
  }) : super(key: key);

  final String url;
  final void Function() onClose;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: photoCardSize,
        height: photoCardSize,
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(textFieldRadius),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              SizedBox(
                width: photoCardSize,
                height: photoCardSize,
                child: LoadableImage(url: url),
              ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: Align(
                    alignment: Alignment.topRight,
                    // Использую GestureDetector по условиям задачи, хотя он тут
                    // не очень хорошо подходит.
                    child: GestureDetector(
                      onTap: onClose,
                      child: Padding(
                        padding: clearPadding,
                        child: SvgPicture.asset(
                          Svg24.clear,
                          width: clearIconSize,
                          height: clearIconSize,
                          color: mainColor100,
                        ),
                      ),
                    ),
                    // child: SvgButton(
                    //   assetClear,
                    //   iconSize: clearIconSize,
                    //   width: clearButtonSize,
                    //   height: clearButtonSize,
                    //   color: mainColor100,
                    //   highlightColor: highlightColorDark2,
                    //   splashColor: splashColorDark2,
                    //   onPressed: onClose,
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
