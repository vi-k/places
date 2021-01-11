import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/category.dart';
import '../../domain/mocks_data.dart';
import '../../domain/sight.dart';
import '../../utils/focus.dart';
import '../../utils/maps.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../widget/add_photo_card.dart';
import '../widget/failed.dart';
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

  final int? sightId;

  @override
  _SightEditScreenState createState() => _SightEditScreenState();
}

class _SightEditScreenState extends State<SightEditScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _categoryId;
  final _photos = <String>[];
  var _mockPhotosCounter = 0;
  String? _name;
  double? _lat;
  double? _lon;
  String? _details;
  late TextEditingController _nameController;
  late TextEditingController _latController;
  late TextEditingController _lonController;
  late TextEditingController _detailsController;

  bool get isNew => widget.sightId == null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _latController = TextEditingController();
    _lonController = TextEditingController();
    _detailsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: SmallAppBar(
        title: isNew ? stringNewPlace : stringEdit,
        back: stringCancel,
      ),
      body: isNew
          ? _buildBody(_formKey, theme)
          : Loader<Sight>(
              load: () => widget.sightId == null
                  ? Future.value(null)
                  : Mocks.of(context).sightById(widget.sightId!).then((sight) {
                      _photos
                        ..clear()
                        ..addAll(sight.photos);
                      _categoryId = sight.categoryId;
                      _nameController.value =
                          TextEditingValue(text: sight.name);
                      _latController.value = TextEditingValue(
                          text: sight.coord.lat.toStringAsFixed(6));
                      _lonController.value = TextEditingValue(
                          text: sight.coord.lon.toStringAsFixed(6));
                      _detailsController.value =
                          TextEditingValue(text: sight.details);

                      return sight;
                    }),
              error: (context, error) => Failed(
                error.toString(),
                onRepeat: () => Loader.of<Sight>(context).reload(),
              ),
              builder: (context, _, sight) => _buildBody(_formKey, theme),
            ),
    );
  }

  // Содержимое экрана.
  Widget _buildBody(Key? key, MyThemeData theme) => Column(
        children: [
          Form(
            key: key,
            child: Expanded(
              child: ListView(
                children: [
                  _buildPhotoGallery(),
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
  // ListView для строки не очень подходит, т.к. занимает всё пространтсво
  // по вертикали. Можно ограничить только явным указанием размера. В то время
  // как SingleChildScrollView + Row подстраиваются под размер. Это удобнее.
  Widget _buildPhotoGallery() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: commonSpacing),
            AddPhotoCard(
              onPressed: () {
                // Временно добавляем моковые фотографии.
                if (_mockPhotosCounter >= mockPhotos.length) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Добавили всё, что можно')),
                  );
                } else {
                  setState(() {
                    _photos.add(mockPhotos[_mockPhotosCounter++]);
                  });
                }
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
  void _getCategory() {
    Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) => CategorySelectScreen(id: _categoryId),
        )).then((value) {
      if (value != null) {
        setState(() {
          _categoryId = value;
        });
      }
    });
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
          label: isNew ? stringCreate : stringSave,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Если не выбрана категория, предупреждаем об этом пользователя
              // и отправляем его на страницу выбора категории.
              if (_categoryId == null) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text(stringNoCategory)));
                _getCategory();
                return;
              }

              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                  title: Text(isNew ? stringDoCreate : stringDoSave),
                  actions: [
                    SmallButton(
                      label: stringNo,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SmallButton(
                      label: stringYes,
                      onPressed: () {
                        _formKey.currentState!.save();

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

                        Navigator.pop(context);
                        Navigator.pop(context, id);
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
}
