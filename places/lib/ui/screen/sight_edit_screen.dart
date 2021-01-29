import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/category.dart';
import '../../domain/sight.dart';
import '../../utils/focus.dart';
import '../../utils/maps.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../widget/add_photo_card.dart';
import '../widget/failed.dart';
import '../widget/get_image.dart';
import '../widget/loader.dart';
import '../widget/mocks.dart';
import '../widget/photo_card.dart';
import '../widget/section.dart';
import '../widget/small_app_bar.dart';
import '../widget/small_button.dart';
import '../widget/small_loader.dart';
import '../widget/standart_button.dart';
import 'category_select_screen.dart';

/// Экран добавления места.
class SightEditScreen extends StatefulWidget {
  const SightEditScreen({
    Key? key,
    this.sightId,
  }) : super(key: key);

  /// Идентификатор места.
  ///
  /// Если передан `null`, то новое место.
  final int? sightId;

  @override
  _SightEditScreenState createState() => _SightEditScreenState();
}

class _SightEditScreenState extends State<SightEditScreen> {
  final _formKey = GlobalKey<FormState>();
  Sight? _sight;
  int? _categoryId;
  final _photos = <String>[];
  String? _name;
  double? _lat;
  double? _lon;
  String? _details;
  late TextEditingController _nameController;
  late TextEditingController _latController;
  late TextEditingController _lonController;
  late TextEditingController _detailsController;

  bool get _isNew => widget.sightId == null;

  bool _cmpLists(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final bi = b.iterator;
    for (final va in a) {
      bi.moveNext();
      if (va != bi.current) return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _latController = TextEditingController();
    _lonController = TextEditingController();
    _detailsController = TextEditingController();
  }

  // Проверяет данные перед сохранением.
  bool _validate() {
    if (!_formKey.currentState!.validate()) return false;

    // Если не выбрана категория, предупреждаем об этом пользователя
    // и отправляем его на страницу выбора категории.
    if (_categoryId == null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(stringNoCategory)));
      _getCategory();
      return false;
    }

    return true;
  }

  // Проверяет, нужно ли сохранять.
  bool _needSave({bool forced = false}) {
    _formKey.currentState!.save();

    final sight = _sight;
    if (sight == null) return true;

    return forced ||
        sight.name != _name ||
        sight.categoryId != _categoryId ||
        sight.coord.lat != _lat ||
        sight.coord.lon != _lon ||
        sight.details != _details ||
        !_cmpLists(sight.photos, _photos);
  }

  // Сохраняет изменения.
  int _save() {
    var id = widget.sightId;

    final newSight = Sight(
      id: id ?? 0,
      name: _name!,
      coord: Coord(_lat!, _lon!),
      photos: _photos,
      details: _details!,
      categoryId: _categoryId!,
    );

    if (id == null) {
      id = Mocks.of(context).addSight(newSight);
    } else {
      Mocks.of(context).replaceSight(id, newSight);
    }

    return id;
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: SmallAppBar(
        title: _isNew ? stringNewPlace : stringEdit,
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
              title: Text(_isNew ? stringDoCreate : stringDoSave),
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
                  onPressed: () {
                    // Закрываем диалог.
                    Navigator.pop(context);
                    // Возвращаемся назад с сохранением изменений.
                    Navigator.pop(context, _save());
                  },
                ),
              ],
            ),
          );

          return false;
        },
        child: _isNew
            ? _buildBody(context, _formKey, theme)
            : Loader<Sight?>(
                load: () async {
                  if (widget.sightId == null) return null;
                  final sight =
                      await Mocks.of(context).sightById(widget.sightId!);

                  // Копируем все значения sight.
                  _photos
                    ..clear()
                    ..addAll(sight.photos);
                  _categoryId = sight.categoryId;
                  _nameController.value = TextEditingValue(text: sight.name);
                  _latController.value = TextEditingValue(
                      text: sight.coord.lat.toStringAsFixed(6));
                  _lonController.value = TextEditingValue(
                      text: sight.coord.lon.toStringAsFixed(6));
                  _detailsController.value =
                      TextEditingValue(text: sight.details);

                  // Полученный sight сохраняем, чтобы понять потом, были ли
                  // сделаны изменения.
                  return _sight = sight;
                },
                error: (context, error) => Failed(
                  error.toString(),
                  onRepeat: () => Loader.of<Sight>(context).reload(),
                ),
                builder: (context, _, sight) =>
                    _buildBody(context, _formKey, theme),
              ),
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
                  _buildCategory(theme),
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

  // Категория.
  Widget _buildCategory(MyThemeData theme) => Section(
        stringCategory,
        spacing: 0,
        applyPaddingToChild: false,
        child: _categoryId == null
            ? _buildCategoryTile(theme, null, loaded: false)
            : Loader<Category>(
                tag: _categoryId,
                load: _categoryId == null
                    ? null
                    : () => Mocks.of(context).categoryById(_categoryId!),
                loader: (_) => const Center(
                      child: SmallLoader(),
                    ),
                error: (context, error) => Failed(
                      error.toString(),
                      onRepeat: () => Loader.of<Category>(context).reload(),
                    ),
                builder: (context, done, category) =>
                    _buildCategoryTile(theme, category, loaded: true)),
      );

  ListTile _buildCategoryTile(MyThemeData theme, Category? category,
          {required bool loaded}) =>
      ListTile(
        title: Text(
          loaded ? (category?.name ?? '') : stringUnselected,
          style: theme.textRegular16Light,
        ),
        trailing: SvgPicture.asset(
          Svg24.view,
          color: theme.mainTextColor2,
        ),
        onTap: _getCategory,
      );

  // Получение категории.
  Future<void> _getCategory() async {
    final categoryId = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectScreen(id: _categoryId),
      ),
    );

    if (categoryId != null) {
      setState(() {
        _categoryId = categoryId;
      });
    }
  }

  // Название.
  Widget _buildName() => Section(
        stringName,
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: _isNew ? stringNewPlaceFakeName : '',
          ),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).nextEditableTextFocus();
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => value!.isEmpty ? stringRequiredField : null,
          onSaved: (value) {
            _name = value;
          },
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
                    hintText: _isNew ? stringNewPlaceFakeLatitude : '',
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
                  onSaved: (value) {
                    _lat = double.parse(value!);
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
                    hintText: _isNew ? stringNewPlaceFakeLongitude : '',
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
                  onSaved: (value) {
                    _lon = double.parse(value!);
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
          controller: _detailsController,
          minLines: 3,
          maxLines: 10,
          textInputAction: TextInputAction.done,
          onSaved: (value) {
            _details = value;
          },
        ),
      );

  // Кнопка создания/сохранения
  Widget _buildDone(BuildContext context) => Container(
        width: double.infinity,
        padding: commonPadding,
        child: StandartButton(
          label: _isNew ? stringCreate : stringSave,
          onPressed: () {
            if (!_validate()) return;
            // Возвращаемся.
            Navigator.pop(context, _needSave(forced: true) ? _save() : null);
          },
        ),
      );
}
