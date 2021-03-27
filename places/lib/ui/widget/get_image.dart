import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/bloc/app_bloc.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/utils/let_and_also.dart';

import 'edit_dialog.dart';
import 'small_button.dart';
import 'standart_button.dart';

var _mockPhotosCounter = -1;
const _mockPhotos = [
  'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9c/Russian_chapel_at_Fort_Ross_%282016%29.jpg/1280px-Russian_chapel_at_Fort_Ross_%282016%29.jpg',
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
  'https://architectureguru.ru/wp-content/uploads/2015/09/1-18.jpg',
];

String get _nextMockPhoto {
  if (++_mockPhotosCounter >= _mockPhotos.length) _mockPhotosCounter = 0;
  return _mockPhotos[_mockPhotosCounter];
}

class GetImageResult {
  GetImageResult({this.url, this.path})
      : assert(url != null && path == null || url == null && path != null);

  final String? url;
  final String? path;
}

/// Выбора источника фотографии места: камера, галерея, файл.
class GetImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;
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
                _buildItem(context, style, Svg24.camera, stringCamera,
                    () => _getImage(context, ImageSource.camera)),
                _buildDivider(),
                _buildItem(context, style, Svg24.photo, stringPhoto,
                    () => _getImage(context, ImageSource.gallery)),
                _buildDivider(),
                _buildItem(context, style, Svg24.share, stringUrl,
                    () => _getUrl(context)),
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

  Future<void> _getImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    Navigator.pop(
        context, pickedFile?.let((it) => GetImageResult(path: it.path)));
  }

  Future<void> _getUrl(BuildContext context) async {
    final url = await showDialog<String?>(
      context: context,
      builder: (_) => EditDialog(
        title: const Text(stringDoEnterUrl),
        builder: (context, controller) => TextField(
          controller: controller,
          autofocus: true,
          minLines: 1,
          maxLines: 10,
        ),
      ),
    );

    Navigator.pop(context, url?.let((it) => GetImageResult(url: it)));
  }
}
