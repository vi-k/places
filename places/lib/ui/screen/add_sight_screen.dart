/// Экран добавления места.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/focus.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/my_theme.dart';
import '../widget/section.dart';
import '../widget/small_app_bar.dart';
import '../widget/small_button.dart';
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCategory(theme),
                  _buildName(),
                  ..._buildCoord(context, theme),
                  // Описание
                  _buildDescription(),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
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
    );
  }

  Section _buildCategory(MyThemeData theme) => Section(
        stringCategory,
        spacing: 0,
        applyPaddingToChild: false,
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
      );

  Section _buildName() => Section(
        stringName,
        child: TextFormField(
          focusNode: focusNodeName,
          initialValue: 'Золотая долина',
          textInputAction: TextInputAction.next,
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
                  focusNode: focusNodeLatitude,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            const SizedBox(width: MyThemeData.sectionHSpacing),
            Expanded(
              child: Section(
                stringLongitude,
                left: 0,
                child: TextFormField(
                  focusNode: focusNodeLongitude,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
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

            },
          ),
        ),
      ];

  Section _buildDescription() {
    return Section(
      stringDescription,
      child: TextFormField(
        focusNode: focusNodeDescription,
        minLines: 3,
        maxLines: 10,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
