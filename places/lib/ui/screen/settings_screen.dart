import 'package:flutter/material.dart';

import '../../app.dart';
import '../res/strings.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/my_theme.dart';
import '../widget/short_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: const ShortAppBar(
        title: stringSettings,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(
              stringIsDark,
              style: theme.textRegular14Main,
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
              style: theme.textRegular14Main,
            ),
            trailing: Icon(
              Icons.info_outline,
              color: theme.textButtonPrimaryTextStyle.color,
            ),
          ),
          const Divider(),
        ],
      ),
      bottomNavigationBar: const AppNavigationBar(index: 3),
    );
  }
}
