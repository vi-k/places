import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/mocks_data.dart';
import '../../domain/sight.dart';
import '../../utils/focus.dart';
import '../../utils/maps.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/add_photo_card.dart';
import '../widget/mocks.dart';
import '../widget/photo_card.dart';
import '../widget/section.dart';
import '../widget/small_app_bar.dart';
import '../widget/small_button.dart';
import '../widget/standart_button.dart';

/// Экран добавления места.
class SightScreen extends StatefulWidget {
  const SightScreen({
    Key? key,
    this.sight,
  }) : super(key: key);

  final Sight? sight;

  @override
  _SightScreenState createState() => _SightScreenState();
}

class _SightScreenState extends State<SightScreen> {
  final _formKey = GlobalKey<FormState>();
  SightCategory? _category;
  final _photos = <String>[];
  var _mockPhotosCounter = 0;
  String? _name;
  double? _lat;
  double? _lon;
  String? _details;

  bool get isNew => widget.sight == null;

  @override
  void initState() {
    super.initState();

    // В экране редактирования нам не нужно следить за изменениями.
    // А прочитать данные из провайдера можем и здесь.
    if (!isNew) {
      final sight = widget.sight!;
      _photos.addAll(sight.photos);
      _category = sight.category;
      _name = sight.name;
      _lat = sight.coord.lat;
      _lon = sight.coord.lon;
      _details = sight.details;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: SmallAppBar(
        title: isNew ? stringNewPlace : stringEdit,
        back: stringCancel,
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Expanded(
              child: ListView(
                children: [
                  _buildPhotoGallery(context),
                  _buildCategory(theme),
                  _buildName(),
                  ..._buildCoord(context, theme),
                  _buildDetails(),
                ],
              ),
            ),
          ),
          _buildDone(context),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery(BuildContext context) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
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
        ),
      );

  Widget _buildCategory(MyThemeData theme) => Section(
        stringCategory,
        // Временное решение для выбора категории вместо отдельного экрана
        child: DropdownButtonFormField<SightCategory>(
          value: _category,
          items: [
            for (final category in SightCategory.values)
              DropdownMenuItem(
                value: category,
                child: Text(category.text),
              ),
          ],
          decoration: const InputDecoration(
            hintText: stringUnselected,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null) return stringRequiredField;
            return null;
          },
          onChanged: (value) {
            _category = value;
            FocusScope.of(context).nextEditableTextFocus();
          },
        ),
        // Заготовка для выбора категории с помощью дополнительного экрана
        // spacing: 0,
        // applyPaddingToChild: false,
        // child: ListTile(
        //   title: Text(
        //     stringUnselected,
        //     style: theme.textRegular16Light,
        //   ),
        //   trailing: SvgPicture.asset(
        //     assetForward,
        //     color: theme.mainTextColor2,
        //   ),
        //   onTap: () {},
        // ),
      );

  Widget _buildName() => Section(
        stringName,
        child: TextFormField(
          initialValue: _name ?? 'Моя работа', // Временно. Для тестов
          decoration: const InputDecoration(
            hintText: stringNewPlaceFakeName,
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

  List<Widget> _buildCoord(BuildContext context, MyThemeData theme) => [
        Row(
          children: [
            Expanded(
              child: Section(
                stringLatitude,
                right: 0,
                child: TextFormField(
                  initialValue: _lat?.toStringAsFixed(6) ??
                      '48.506642', // Временно. Для тестов
                  decoration: const InputDecoration(
                    hintText: stringNewPlaceFakeLatitude,
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).nextEditableTextFocus();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _checkCoord,
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
                  initialValue: _lon?.toStringAsFixed(6) ??
                      '135.138573', // Временно. Для тестов
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: stringNewPlaceFakeLongitude,
                  ),
                  validator: _checkCoord,
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

  Widget _buildDetails() => Section(
        stringDescription,
        child: TextFormField(
          initialValue: _details,
          minLines: 3,
          maxLines: 10,
          textInputAction: TextInputAction.done,
          onSaved: (value) {
            _details = value;
          },
        ),
      );

  Widget _buildDone(BuildContext context) => Container(
        width: double.infinity,
        padding: commonPadding,
        child: StandartButton(
          label: isNew ? stringCreate : stringSave,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
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

                        var id = widget.sight?.id;

                        final newSight = Sight(
                          id: id ?? 0,
                          name: _name!,
                          coord: Coord(_lat!, _lon!),
                          photos: _photos,
                          details: _details!,
                          category: _category!,
                        );

                        if (id == null) {
                          id = Mocks.of(context).add(newSight);
                        } else {
                          Mocks.of(context).replace(id, newSight);
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

  String? _checkCoord(String? value) {
    if (value == null || value.isEmpty) {
      return stringRequiredField;
    }

    if (double.tryParse(value) == null) return stringInvalidValue;

    return null;
  }
}
