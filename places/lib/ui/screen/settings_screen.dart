import 'package:flutter/material.dart';

import '../../app.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/my_theme.dart';
import '../widget/short_app_bar.dart';

/// Экран настроек.
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
          const _ListDivider(),
          ListTile(
            title: Text(
              settingsTutorial,
              style: theme.textRegular14Main,
            ),
            trailing: Icon(
              Icons.info_outline,
              color: theme.accentColor,
            ),
            onTap: () {
              print('Смотреть туториал');
            }
          ),
          const _ListDivider(),
        ],
      ),
      bottomNavigationBar: const AppNavigationBar(index: 3),
    );
  }
}

class _ListDivider extends StatelessWidget {
  const _ListDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: MyThemeData.commonPadding.left,
      endIndent: MyThemeData.commonPadding.right,
      height: 1,
    );
  }
}
