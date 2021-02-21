import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';

import 'standart_button.dart';

var _mockPhotosCounter = -1;
const _mockPhotos = [
  'https://top10.travel/wp-content/uploads/2014/12/hram-vasiliya-blazhennogo.jpg',
  'https://img.gazeta.ru/files3/957/10301957/00-pic905-895x505-58873.jpg',
  'https://way2day.com/wp-content/uploads/2018/06/Dostoprimechatelnosti-Turtsii.jpg',
  'https://uploads.europa24.ru/rs/580w/news/2017-08/berlinskiy-dom-59819f21c5469.jpg',
  'https://top10.travel/wp-content/uploads/2014/09/brandenburgskie-vorota-1.jpg',
  'https://vibirai.ru/image/1155920.w640.jpg',
  'https://kor.ill.in.ua/m/610x385/2445355.jpg',
  'https://www.topkurortov.com/wp-content/uploads/2015/12/pizanskaya-bashnia.jpg',
  'https://tripplanet.ru/wp-content/uploads/europe/england/london/london-dostoprimechatelnosti.jpg',
  'https://crimeaguide.com/wp-content/uploads/2016/05/last.jpg',
];

String get _nextMockPhoto {
  if (++_mockPhotosCounter >= _mockPhotos.length) _mockPhotosCounter = 0;
  return _mockPhotos[_mockPhotosCounter];
}

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
                  Navigator.pop(context, _nextMockPhoto);
                }),
                _buildDivider(),
                _buildItem(context, style, Svg24.photo, stringPhoto, () {
                  // Временно добавляем моковые фотографии.
                  Navigator.pop(context, _nextMockPhoto);
                }),
                _buildDivider(),
                _buildItem(context, style, Svg24.file, stringFile, () {
                  // Временно добавляем моковые фотографии.
                  Navigator.pop(context, _nextMockPhoto);
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
