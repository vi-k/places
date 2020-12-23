/// Экран добавления места.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/my_theme.dart';
import '../widget/section.dart';
import '../widget/small_app_bar.dart';
import '../widget/standart_button.dart';

class AddSightScreen extends StatefulWidget {
  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen> {
  late FocusNode focusNodeName;
  late FocusNode focusNodeLatitude;
  late FocusNode focusNodeLongitude;
  late FocusNode focusNodeDescription;

  @override
  void initState() {
    super.initState();

    focusNodeName = FocusNode();
    focusNodeLatitude = FocusNode();
    focusNodeLongitude = FocusNode();
    focusNodeDescription = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: const SmallAppBar(
        title: stringNewPlace,
        back: stringCancel,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Section(
              stringCategory,
              padding: EdgeInsets.zero,
              child: ListTile(
                title: Text(
                  stringUnselected,
                  style: theme.textRegular16Light,
                ),
                trailing: SvgPicture.asset(
                  assetForward,
                  color: theme.mainTextColor2,
                ),
                onTap: () {},
              ),
            ),
            Section(
              stringName,
              child: TextFormField(
                focusNode: focusNodeName,
                initialValue: 'Золотая долина',
                style: theme.textRegular16Main2,
                onEditingComplete: () {
                  focusNodeLatitude.nextFocus();
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Section(
                    stringLatitude,
                    child: TextFormField(
                        focusNode: focusNodeLatitude,
                        keyboardType: TextInputType.number,
                        style: theme.textRegular16Main2,
                        onEditingComplete: () {
                          focusNodeLatitude.nextFocus();
                        }),
                  ),
                ),
                Expanded(
                  child: Section(
                    stringLongitude,
                    child: TextFormField(
                      focusNode: focusNodeLongitude,
                      keyboardType: TextInputType.number,
                      style: theme.textRegular16Main2,
                      onEditingComplete: () {
                        focusNodeLatitude.nextFocus();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Section(
              stringDescription,
              child: TextFormField(
                focusNode: focusNodeDescription,
                minLines: 3,
                maxLines: 10,
                style: theme.textRegular16Main2,
              ),
            ),
            Padding(
              padding: MyThemeData.commonPadding,
              child: StandartButton(
                label: stringCreate,
                onPressed: () {
                  print('create place');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
