import 'package:flutter/material.dart';

import '../res/const.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/app_navigation_bar.dart';
import '../widget/settings.dart';
import '../widget/small_app_bar.dart';

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
      appBar: const SmallAppBar(
        title: stringSettings,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(
              stringIsDark,
              style: theme.textRegular14Main,
            ),
            value: Settings.of(context, listen: true).isDark,
            onChanged: (value) {
              Settings.of(context).isDark = value;
            },
          ),
          const _ListDivider(),
          ListTile(
              title: Text(
                stringWatchTutorial,
                style: theme.textRegular14Main,
              ),
              trailing: Icon(
                Icons.info_outline,
                color: theme.accentColor,
              ),
              onTap: () {
                print('Смотреть туториал');
              }),
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
  Widget build(BuildContext context) => Divider(
        indent: commonPadding.left,
        endIndent: commonPadding.right,
        height: 1,
      );
}
