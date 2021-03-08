import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mwwm/mwwm.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/place_edit_wm.dart';
import 'package:places/ui/widget/add_photo_card.dart';
import 'package:places/ui/widget/get_image.dart';
import 'package:places/ui/widget/photo_card.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/standart_button.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/focus.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:relation/relation.dart';

import 'place_type_select_screen.dart';

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final place = wm.placeState.value.data;
    if (place != null) {
      _nameController.text = place.name;
      _latController.text = place.coord.lat.toStringAsFixed(6);
      _lonController.text = place.coord.lon.toStringAsFixed(6);
      _descriptionController.text = place.description;
    }
  }

  bool _cmpLists(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final bi = b.iterator;
    for (final va in a) {
      bi.moveNext();
      if (va != bi.current) return false;
    }

    return true;
  }

  // Проверяет данные перед сохранением.
  bool _validate() {
    if (!_formKey.currentState!.validate()) return false;

    // Если не выбран тип места, предупреждаем об этом пользователя
    // и отправляем его на страницу выбора типа.
    if (wm.placeTypeState.value.data == null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(stringNoPlaceType)));
      _getPlaceType();
      return false;
    }

    return true;
  }

  // Проверяет, нужно ли сохранять.
  bool _needSave({bool forced = false}) {
    _formKey.currentState!.save();

    final place = wm.placeState.value.data;
    if (place == null) return true;

    return forced ||
        place.name != _nameController.text ||
        place.type != wm.placeTypeState.value.data?.type ||
        place.coord.lat != double.parse(_latController.text) ||
        place.coord.lon != double.parse(_lonController.text) ||
        place.description != _descriptionController.text ||
        !_cmpLists(place.photos, wm.photosState.value.data);
  }

  // Сохраняет изменения.
  Future<Place> _save() => wm.savePlace(
        name: _nameController.text,
        coord: Coord(
          double.parse(_latController.text),
          double.parse(_lonController.text),
        ),
        description: _descriptionController.text,
      );

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: SmallAppBar(
        title: wm.isNew ? stringNewPlace : stringEdit,
        back: stringCancel,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (!_validate()) {
            final exit = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text(stringDoCancel),
                actions: [
                  SmallButton(
                    label: stringCancel,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  SmallButton(
                    label: stringYes,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            );

            return exit ?? false;
          }

          if (!_needSave()) return true;

          await showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(wm.isNew ? stringDoCreate : stringDoSave),
              actions: [
                SmallButton(
                  label: stringNo,
                  onPressed: () {
                    // Закрываем диалог.
                    Navigator.pop(context);
                    // Возвращаемся назад без сохранения изменений.
                    Navigator.pop(context, null);
                  },
                ),
                SmallButton(
                  label: stringYes,
                  onPressed: () async {
                    final place = await _save();
                    // Закрываем диалог.
                    Navigator.pop(context);
                    // Возвращаемся назад с сохранением изменений.
                    Navigator.pop(context, place);
                  },
                ),
              ],
            ),
          );

          return false;
        },
        child: _buildBody(context, _formKey, theme),
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
  // ListView для строки не очень подходит, т.к. занимает всё пространство
  // по вертикали. Можно ограничить только явным указанием размера. В то время
  // как SingleChildScrollView + Row подстраиваются под размер. Это удобнее.
  Widget _buildPhotoGallery(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: EntityStateBuilder<List<String>>(
          streamedState: wm.photosState,
          child: (context, photos) => Row(
            children: [
              const SizedBox(width: commonSpacing),
              AddPhotoCard(
                onPressed: () async {
                  final url = await showModalBottomSheet<String>(
                    context: context,
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: Colors.transparent,
                    builder: (context) => GetImage(),
                  );

                  if (url == null) return;
                  wm.addPhoto(url);
                },
              ),
              for (final photo in photos) ...[
                const SizedBox(width: commonSpacing),
                Dismissible(
                  key: ValueKey(photo),
                  direction: DismissDirection.up,
                  onDismissed: (_) {
                    wm.removePhoto(photo);
                  },
                  child: PhotoCard(
                    url: photo,
                    onClose: () {
                      wm.removePhoto(photo);
                    },
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
          onTap: _getPlaceType,
        ),
      );

  // Получение типа места.
  Future<void> _getPlaceType() async {
    final placeType = await Navigator.push<PlaceType>(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceTypeSelectScreen(
            placeType: wm.placeTypeState.value.data?.type),
      ),
    );

    if (placeType != null) {
      await wm.placeTypeState.content(PlaceTypeUi(placeType));
    }
  }

  // Название.
  Widget _buildName() => Section(
        stringName,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: wm.isNew ? stringNewPlaceFakeName : '',
          ),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).nextEditableTextFocus();
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => value!.isEmpty ? stringRequiredField : null,
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
                  controller: _latController,
                  decoration: InputDecoration(
                    hintText: wm.isNew ? stringNewPlaceFakeLatitude : '',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).nextEditableTextFocus();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return stringRequiredField;
                    }

                    final lat = double.tryParse(value);
                    if (lat == null || lat < -90 || lat > 90) {
                      return stringInvalidValue;
                    }

                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(width: commonSpacing),
            Expanded(
              child: Section(
                stringLongitude,
                left: 0,
                child: TextFormField(
                  controller: _lonController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: wm.isNew ? stringNewPlaceFakeLongitude : '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return stringRequiredField;
                    }

                    final lon = double.tryParse(value);
                    if (lon == null || lon < -180 || lon > 180) {
                      return stringInvalidValue;
                    }

                    return null;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).nextEditableTextFocus();
                  },
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
          controller: _descriptionController,
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
            onPressed: () async {
              if (!_validate()) return;
              // Сохраняем и возвращаемся.
              Navigator.pop(
                  context, _needSave(forced: true) ? await _save() : null);
            },
          ),
        ),
      );
}
