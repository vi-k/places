import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mwwm/mwwm.dart';
import 'package:places/data/model/place.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/place_edit_wm.dart';
import 'package:places/ui/widget/add_photo_card.dart';
import 'package:places/ui/widget/photo_card.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/standart_button.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:relation/relation.dart';

/// Экран добавления места.
class PlaceEditScreen extends CoreMwwmWidget {
  const PlaceEditScreen({
    Key? key,
    this.place,
    WidgetModelBuilder? wmBuilder,
  }) : super(
          key: key,
          widgetModelBuilder: wmBuilder ?? PlaceEditWm.builder,
        );

  /// Идентификатор места.
  ///
  /// Если передан `null`, то новое место.
  final Place? place;

  @override
  _PlaceEditScreenState createState() => _PlaceEditScreenState();
}

class _PlaceEditScreenState extends WidgetState<PlaceEditWm> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: SmallAppBar(
        title: wm.isNew ? stringNewPlace : stringEdit,
        back: stringCancel,
      ),
      body: WillPopScope(
        onWillPop: wm.onWillPop,
        child: _buildBody(context, wm.formKey, theme),
      ),
    );
  }

  // Содержимое экрана.
  Widget _buildBody(BuildContext context, Key? key, MyThemeData theme) =>
      Column(
        children: [
          Form(
            key: key,
            child: Expanded(
              child: ListView(
                children: [
                  _buildPhotoGallery(context),
                  _buildPlaceType(theme),
                  _buildName(),
                  ..._buildCoord(theme),
                  _buildDetails(),
                ],
              ),
            ),
          ),
          _buildDone(context),
        ],
      );

  // Фотографии мест.
  Widget _buildPhotoGallery(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: EntityStateBuilder<List<String>>(
          streamedState: wm.photosState,
          child: (context, photos) => Row(
            children: [
              const SizedBox(width: commonSpacing),
              AddPhotoCard(
                onPressed: wm.addPhoto,
              ),
              for (final photo in photos) ...[
                const SizedBox(width: commonSpacing),
                Dismissible(
                  key: ValueKey(photo),
                  direction: DismissDirection.up,
                  onDismissed: (_) => wm.removePhoto(photo),
                  child: PhotoCard(
                    url: photo,
                    onClose: () => wm.removePhoto(photo),
                  ),
                ),
              ],
              const SizedBox(width: commonSpacing),
            ],
          ),
        ),
      );

  // Тип места.
  Widget _buildPlaceType(MyThemeData theme) => Section(
        stringPlaceType,
        spacing: 0,
        applyPaddingToChild: false,
        child: ListTile(
          title: EntityStateBuilder<PlaceTypeUi?>(
            streamedState: wm.placeTypeState,
            child: (context, placeType) => Text(
              placeType?.name ?? stringUnselected,
              style: theme.textRegular16Light,
            ),
          ),
          trailing: SvgPicture.asset(
            Svg24.view,
            color: theme.mainTextColor2,
          ),
          onTap: wm.getPlaceType,
        ),
      );

  // Название.
  Widget _buildName() => Section(
        stringName,
        child: TextFormField(
          controller: wm.nameController,
          decoration: InputDecoration(
            hintText: wm.isNew ? stringNewPlaceFakeName : '',
          ),
          textInputAction: TextInputAction.next,
          onEditingComplete: wm.nextEditableTextFocus,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: wm.nameValidator,
        ),
      );

  // Координаты.
  List<Widget> _buildCoord(MyThemeData theme) => [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Section(
                stringLatitude,
                right: 0,
                child: TextFormField(
                  controller: wm.latController,
                  decoration: InputDecoration(
                    hintText: wm.isNew ? stringNewPlaceFakeLatitude : '',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: wm.nextEditableTextFocus,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: wm.latValidator,
                ),
              ),
            ),
            const SizedBox(width: commonSpacing),
            Expanded(
              child: Section(
                stringLongitude,
                left: 0,
                child: TextFormField(
                  controller: wm.lonController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: wm.isNew ? stringNewPlaceFakeLongitude : '',
                  ),
                  validator: wm.lonValidator,
                  onEditingComplete: wm.nextEditableTextFocus,
                ),
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          child: SmallButton(
            label: stringLocateOnTheMap,
            style: theme.textMiddle16Accent,
            onPressed: () {
              print('Указать на карте');
            },
          ),
        ),
      ];

  // Описание.
  Widget _buildDetails() => Section(
        stringDescription,
        child: TextFormField(
          controller: wm.descriptionController,
          minLines: 3,
          maxLines: 10,
          textInputAction: TextInputAction.done,
        ),
      );

  // Кнопка создания/сохранения
  Widget _buildDone(BuildContext context) => Container(
        width: double.infinity,
        padding: commonPadding,
        child: EntityStateBuilder<Place>(
          streamedState: wm.placeState,
          loadingChild: const Center(
            child: CircularProgressIndicator(),
          ),
          child: (context, place) => StandartButton(
            label: wm.isNew ? stringCreate : stringSave,
            onPressed: wm.done,
          ),
        ),
      );
}
