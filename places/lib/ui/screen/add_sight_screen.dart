import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/sight.dart';
import '../../mocks.dart';
import '../../utils/focus.dart';
import '../../utils/maps.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/my_theme.dart';
import '../widget/section.dart';
import '../widget/small_app_bar.dart';
import '../widget/small_button.dart';
import '../widget/standart_button.dart';

/// Экран добавления места.
class AddSightScreen extends StatefulWidget {
  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen> {
  final _formKey = GlobalKey<FormState>();
  SightCategory? _category;
  String? _name;
  double? _lat;
  double? _lon;
  String? _details;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: const SmallAppBar(
        title: stringNewPlace,
        back: stringCancel,
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCategory(theme),
                    _buildName(),
                    ..._buildCoord(context, theme),
                    _buildDetails(),
                  ],
                ),
              ),
            ),
          ),
          _buildDone(context),
        ],
      ),
    );
  }

  Widget _buildCategory(MyThemeData theme) => Section(
        stringCategory,
        // Временное решение для выбора категории вместо отдельного экрана
        child: DropdownButtonFormField<SightCategory>(
          items: [
            for (final category in SightCategory.values)
              DropdownMenuItem(
                value: category,
                child: Text(category.text),
              ),
          ],
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
          initialValue: 'Моя работа', // Временно. Для тестов
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
                  initialValue: '48.506642', // Временно. Для тестов
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
            const SizedBox(width: MyThemeData.sectionHSpacing),
            Expanded(
              child: Section(
                stringLongitude,
                left: 0,
                child: TextFormField(
                  initialValue: '135.138573', // Временно. Для тестов
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
        padding: MyThemeData.commonPadding,
        child: StandartButton(
          label: stringCreate,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                  title: const Text(stringCreateQuestion),
                  actions: [
                    SmallButton(
                      label: stringNo,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SmallButton(
                      label: stringYes,
                      onPressed: () {
                        _formKey.currentState!.save();

                        mocks.add(Sight(
                          name: _name!,
                          coord: Coord(_lat!, _lon!),
                          url: '',
                          details: _details!,
                          category: _category!,
                        ));

                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
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
