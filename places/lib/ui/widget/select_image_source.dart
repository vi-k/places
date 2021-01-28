import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import 'standart_button.dart';

enum ImageSource { camera, photo, file }

class SelectImageSource extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final style = theme.textRegular16Light;

    return Padding(
      padding: commonPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: theme.backgroundFirst,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                commonSpacing3_4,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListView(
              clipBehavior: Clip.antiAlias,
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: SvgPicture.asset(
                    Svg24.camera,
                    color: style.color,
                  ),
                  title: Text(
                    stringCamera,
                    style: style,
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                const Divider(
                  indent: commonSpacing,
                  endIndent: commonSpacing,
                  height: dividerHeight,
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    Svg24.photo,
                    color: style.color,
                  ),
                  title: Text(
                    stringPhoto,
                    style: style,
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.photo),
                ),
                const Divider(
                  indent: commonSpacing,
                  endIndent: commonSpacing,
                  height: dividerHeight,
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    Svg24.file,
                    color: style.color,
                  ),
                  title: Text(
                    stringFile,
                    style: style,
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.file),
                ),
              ],
            ),
          ),
          const SizedBox(height: commonSpacing1_2),
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundFirst,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(commonSpacing3_4),
            ),
            child: StandartButton(
              color: theme.backgroundFirst,
              label: stringCancel,
              style: theme.textMiddle14Accent,
              onPressed: () => Navigator.pop(context, null),
            ),
          ),
        ],
      ),
    );
  }
}
