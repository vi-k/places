import 'package:flutter/material.dart';

import '../../app.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/short_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ShortAppBar(
          title: settingsTitle,
        ),
        body: ListView(
          children: [
            SwitchListTile(
              title: Text(
                settingsIsDark,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              value: App.of(context).settings.isDark,
              onChanged: (value) {
                App.of(context).settings.isDark = value;
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                settingsTutorial,
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              trailing: const Icon(
                Icons.info_outline,
                color: MyThemeData.buttonColor,
              ),
            ),
            const Divider(),
          ],
        ),
        bottomNavigationBar: const AppNavigationBar(index: 3),
      );
}
