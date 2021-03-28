import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pedantic/pedantic.dart';
import 'package:places/bloc/app_bloc.dart';
import 'package:places/bloc/edit_place_bloc.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/data/model/place_user_info.dart';
import 'package:places/data/repository/location_repository/location_repository.dart';
import 'package:places/main.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/widget/add_photo_card.dart';
import 'package:places/ui/widget/get_image.dart';
import 'package:places/ui/widget/photo_card.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/standart_button.dart';
import 'package:places/utils/coord.dart';
import 'package:places/utils/focus.dart';
import 'package:places/utils/upload_image.dart';
import 'package:places/utils/let_and_also.dart';
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
  late final Place? _place = widget.place;
  PlaceTypeUi? _placeType;
  final _photos = <GetImageResult>[];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool get isNew => _place == null;

  @override
  void initState() {
    super.initState();

    final place = _place;
    if (place != null) {
      _placeType = PlaceTypeUi(place.type);
      _photos.addAll(place.photos.map((e) => GetImageResult(url: e)));
      _nameController.text = place.name;
      _latController.text = place.coord.lat.toStringAsFixed(6);
      _lonController.text = place.coord.lon.toStringAsFixed(6);
      _descriptionController.text = place.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

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
                  _buildPhotoGallery(context, theme),
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
  Widget _buildPhotoGallery(BuildContext context, MyThemeData theme) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: commonSpacing),
            AddPhotoCard(
              onPressed: () async {
                final result = await showModalBottomSheet<GetImageResult>(
                  context: context,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Colors.transparent,
                  builder: (context) => GetImage(),
                );

                if (result == null) return;

                setState(() {
                  _photos.add(result);
                  print('image_picker: ${result.path}');
                });

                final path = result.path;
                if (path != null) {
                  unawaited(uploadPhoto(dio, File(path)).then((url) {
                    if (url == null) return;
                    final index = _photos.indexWhere((e) => e.path == path);
                    setState(() {
                      _photos[index] = GetImageResult(url: url);
                    });
                  }));
                }
              },
            ),
            for (final e in _photos.asMap().entries) ...[
              const SizedBox(width: commonSpacing),
              SizedBox(
                width: photoCardSize,
                height: photoCardSize,
                child: _place != null && e.value.url != null
                    ? Hero(
                        tag: e.value.url ?? '',
                        flightShuttleBuilder: standartFlightShuttleBuilder,
                        child: _buildPhoto(theme, e.value),
                      )
                    : _buildPhoto(theme, e.value),
              ),
            ],
            const SizedBox(width: commonSpacing),
          ],
        ),
      );

  Widget _buildPhoto(MyThemeData theme, GetImageResult photo) => Dismissible(
        key: ValueKey(photo.url.hashCode ^ photo.path.hashCode),
        direction: DismissDirection.up,
        onDismissed: (_) {
          setState(() {
            _photos.removeWhere((e) => e == photo);
          });
        },
        child: PhotoCard(
          url: photo.url,
          path: photo.path,
          onClose: () {
            setState(() {
              _photos.removeWhere((e) => e == photo);
            });
          },
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
    final placeType = await standartNavigatorPush<PlaceType>(
        context, () => PlaceTypeSelectScreen(placeType: _placeType?.type));

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
                    if (!_maybeSave() || !_validate()) return;

                    // Сохраняем.
                    _formKey.currentState!.save();
                    _save(context);
                  },
                ),
        ),
      );

  bool _cmpPhotos(List<String> a, List<GetImageResult> b) {
    if (a.length != b.length) return false;
    final bi = b.iterator;
    for (final va in a) {
      bi.moveNext();
      if (va != bi.current.url) return false;
    }

    return true;
  }

  // Калбэк для WillPopScope
  Future<bool> _onWillPop(BuildContext context) async {
    if (!_maybeSave()) return false;

    // Если нет изменений, выходим сразу.
    if (_validate()) {
      _formKey.currentState!.save();
      if (!_needSave()) return true;
    }

    return await showDialog<bool>(
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
        ) ??
        false;
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

  // Проверяет, можно ли сохранить.
  bool _maybeSave() {
    if (_photos.where((e) => e.url == null).isEmpty) return true;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text(stringNotAllCompleted)));
    return false;
  }

  // Проверяет, нужно ли сохранять.
  bool _needSave() =>
      _place?.let((it) =>
          it.name != _nameController.text ||
          it.type != _placeType?.type ||
          it.coord.lat != double.parse(_latController.text) ||
          it.coord.lon != double.parse(_lonController.text) ||
          it.description != _descriptionController.text ||
          !_cmpPhotos(it.photos, _photos)) ??
      true;

  // Отправляет данные на сохранение.
  Future<void> _save(BuildContext context) async {
    final place = Place(
      id: _place?.id ?? 0,
      name: _nameController.text,
      coord: Coord(
        double.parse(_latController.text),
        double.parse(_lonController.text),
      ),
      photos: _photos.map((e) => e.url!).toList(),
      description: _descriptionController.text,
      type: _placeType!.type,
      userInfo: PlaceUserInfo.zero,
      calcDistanceFrom: await context.read<LocationRepository>().getLocation(),
    );

    context
        .read<EditPlaceBloc>()
        .add(place.isNew ? EditPlaceAdd(place) : EditPlaceUpdate(place));
  }
}
