/// Экран добавления места.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/strings.dart';
import '../widget/my_theme.dart';
import '../widget/section.dart';
import '../widget/small_app_bar.dart';

class AddSightScreen extends StatefulWidget {
  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen> {
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
                keyboardType: TextInputType.text,
                style: theme.textRegular16Main2,
                initialValue: 'Золотая долина',
              ),
            ),
            Section(
              stringName,
              child: TextFormField(),
            ),
          ],
        ),
      ),
    );
  }
}
