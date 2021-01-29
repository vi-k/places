import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import 'mocks.dart';
import 'standart_button.dart';

/// Выбора источника фотографии места: камера, галерея, файл.
class GetImage extends StatelessWidget {
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
                _buildItem(context, style, Svg24.camera, stringCamera, () {
                  // Временно добавляем моковые фотографии.
                  Navigator.pop(context, Mocks.of(context).nextMockPhoto);
                }),
                _buildDivider(),
                _buildItem(context, style, Svg24.photo, stringPhoto, () {
                  // Временно добавляем моковые фотографии.
                  Navigator.pop(context, Mocks.of(context).nextMockPhoto);
                }),
                _buildDivider(),
                _buildItem(context, style, Svg24.file, stringFile, () {
                  // Временно добавляем моковые фотографии.
                  Navigator.pop(context, Mocks.of(context).nextMockPhoto);
                }),
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

  Widget _buildDivider() => const Divider(
        indent: commonSpacing,
        endIndent: commonSpacing,
        height: dividerHeight,
      );

  Widget _buildItem(BuildContext context, TextStyle style, String svg,
          String title, void Function() onTap) =>
      ListTile(
        leading: SvgPicture.asset(
          svg,
          color: style.color,
        ),
        title: Text(
          title,
          style: style,
        ),
        onTap: onTap,
      );
}
