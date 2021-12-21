import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/data/model/photo.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/utils/let_and_also.dart';

import 'edit_dialog.dart';
import 'standart_button.dart';

/// Выбора источника фотографии места: камера, галерея, файл.
class GetImage extends StatefulWidget {
  @override
  _GetImageState createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  late MyThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = context.watch<AppBloc>().theme;
    final style = _theme.textRegular16Light;

    return Padding(
      padding: commonPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMenu(style),
          const SizedBox(height: commonSpacing1_2),
          _buildCancel(context),
        ],
      ),
    );
  }

  Widget _buildCancel(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: _theme.backgroundFirst,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(commonSpacing3_4),
        ),
        child: StandartButton(
          color: _theme.backgroundFirst,
          label: stringCancel,
          style: _theme.textMiddle14Accent,
          onPressed: () => Navigator.pop(context, null),
        ),
      );

  Widget _buildMenu(TextStyle style) => Material(
        color: _theme.backgroundFirst,
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
            _buildItem(
              style,
              Svg24.camera,
              stringCamera,
              () => _getImage(ImageSource.camera),
            ),
            _buildDivider(),
            _buildItem(
              style,
              Svg24.photo,
              stringPhoto,
              () => _getImage(ImageSource.gallery),
            ),
            _buildDivider(),
            _buildItem(
              style,
              Svg24.share,
              stringUrl,
              _getUrl,
            ),
          ],
        ),
      );

  Widget _buildDivider() => const Divider(
        indent: commonSpacing,
        endIndent: commonSpacing,
        height: dividerHeight,
      );

  Widget _buildItem(
    TextStyle style,
    String svg,
    String title,
    void Function() onTap,
  ) =>
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

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    Navigator.pop(context, pickedFile?.let((it) => Photo(path: it.path)));
  }

  Future<void> _getUrl() async {
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

    Navigator.pop(context, url?.let((it) => Photo(url: it)));
  }
}
