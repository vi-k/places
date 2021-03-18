import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/edit_place_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/repository/base/location_repository.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/add_photo_card.dart';
import 'package:places/ui/widget/get_image.dart';
import 'package:places/ui/widget/photo_card.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/standart_button.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/focus.dart';
import 'package:provider/provider.dart';

import 'place_type_select_screen.dart';

/// Экран добавления места.
class PlaceEditScreen extends StatefulWidget {
  const PlaceEditScreen({
    Key? key,
    this.place,
  }) : super(key: key);

  /// Идентификатор места.
  ///
  /// Если передан `null`, то новое место.
  final Place? place;

  @override
  _PlaceEditScreenState createState() => _PlaceEditScreenState();
}

class _PlaceEditScreenState extends State<PlaceEditScreen> {
  final _formKey = GlobalKey<FormState>();
  Place? _place;
  PlaceTypeUi? _placeType;
  final _photos = <String>[];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool get isNew => widget.place == null;

  @override
  void initState() {
    super.initState();

    final place = _place = widget.place;
    if (place != null) {
      _placeType = PlaceTypeUi(place.type);
      _photos.addAll(place.photos);
      _nameController.text = place.name;
      _latController.text = place.coord.lat.toStringAsFixed(6);
      _lonController.text = place.coord.lon.toStringAsFixed(6);
      _descriptionController.text = place.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return BlocProvider<EditPlaceBloc>(
      create: (_) => EditPlaceBloc(context.read<PlaceInteractor>()),
      child: Builder(
          builder: (context) => Scaffold(
                appBar: SmallAppBar(
                  title: isNew ? stringNewPlace : stringEdit,
                  back: stringCancel,
                ),
                body: WillPopScope(
                  onWillPop: () => _onWillPop(context),
                  child: _buildBody(context, _formKey, theme),
                ),
              )),
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
        child: Row(
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
                setState(() {
                  _photos.add(url);
                });
              },
            ),
            for (final photo in _photos) ...[
              const SizedBox(width: commonSpacing),
              Dismissible(
                key: ValueKey(photo),
                direction: DismissDirection.up,
                onDismissed: (_) {
                  setState(() {
                    _photos.remove(photo);
                  });
                },
                child: PhotoCard(
                  url: photo,
                  onClose: () {
                    setState(() {
                      _photos.remove(photo);
                    });
                  },
                ),
              ),
            ],
            const SizedBox(width: commonSpacing),
          ],
        ),
      );

  // Тип места.
  Widget _buildPlaceType(MyThemeData theme) => Section(
        stringPlaceType,
        spacing: 0,
        applyPaddingToChild: false,
        child: ListTile(
          title: Text(
            _placeType?.name ?? stringUnselected,
            style: theme.textRegular16Light,
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
        builder: (context) =>
            PlaceTypeSelectScreen(placeType: _placeType?.type),
      ),
    );

    if (placeType != null) {
      setState(() {
        _placeType = PlaceTypeUi(placeType);
      });
    }
  }

  // Название.
  Widget _buildName() => Section(
        stringName,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: isNew ? stringNewPlaceFakeName : '',
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
                    hintText: isNew ? stringNewPlaceFakeLatitude : '',
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
                    hintText: isNew ? stringNewPlaceFakeLongitude : '',
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
        child: BlocConsumer<EditPlaceBloc, EditPlaceState>(
          listener: (context, state) {
            if (state is EditPlaceSaved) {
              Navigator.pop(context, state.place);
            }
          },
          builder: (context, state) => state is EditPlaceLoading
              ? const Center(child: CircularProgressIndicator())
              : StandartButton(
                  label: isNew ? stringCreate : stringSave,
                  onPressed: () {
                    // Проверяем данные.
                    if (!_validate()) return;
                    // Сохраняем.
                    if (_needSave(forced: true)) _save(context);
                  },
                ),
        ),
      );

  bool _cmpLists(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final bi = b.iterator;
    for (final va in a) {
      bi.moveNext();
      if (va != bi.current) return false;
    }

    return true;
  }

  // Калбэк для WillPopScope
  Future<bool> _onWillPop(BuildContext context) async {
    // Если есть ошибки в данных, диалог: Выйти без сохранения?
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

    // Если нет изменений, выходим сразу.
    if (!_needSave()) return true;

    // Диалог: Сохранить? (Создать?)
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? stringDoCreate : stringDoSave),
        actions: [
          SmallButton(
            label: stringNo,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, null);
            },
          ),
          SmallButton(
            label: stringYes,
            onPressed: () {
              Navigator.pop(context);
              _save(context);
            },
          ),
        ],
      ),
    );

    return false;
  }

  // Проверяет данные перед сохранением.
  bool _validate() {
    if (!_formKey.currentState!.validate()) return false;

    // Если не выбран тип места, предупреждаем об этом пользователя
    // и отправляем его на страницу выбора типа.
    if (_placeType == null) {
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

    final place = _place;
    if (place == null) return true;

    return forced ||
        place.name != _nameController.text ||
        place.type != _placeType?.type ||
        place.coord.lat != double.parse(_latController.text) ||
        place.coord.lon != double.parse(_lonController.text) ||
        place.description != _descriptionController.text ||
        !_cmpLists(place.photos, _photos);
  }

  // Отправляет данные на сохранение.
  void _save(BuildContext context) {
    final place = Place(
      id: _place?.id ?? 0,
      name: _nameController.text,
      coord: Coord(
        double.parse(_latController.text),
        double.parse(_lonController.text),
      ),
      photos: _photos,
      description: _descriptionController.text,
      type: _placeType!.type,
      userInfo: PlaceUserInfo.zero,
      calDistanceFrom: context.read<LocationRepository>().location,
    );

    context
        .read<EditPlaceBloc>()
        .add(place.isNew ? EditPlaceAdd(place) : EditPlaceUpdate(place));
  }
}
