import 'package:flutter/material.dart';
import 'package:places/data/model/settings.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/loader.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/main.dart';

import 'onboarding_screen.dart';

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
            value: Loader.of<Settings>(context).data!.isDark,
            onChanged: (value) {
              settingsInteractor.changeSettings(isDark: value);
              Loader.of<Settings>(context).reload();
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
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => OnboardingScreen(),
              ),
            ),
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
  Widget build(BuildContext context) => const Divider(
        indent: commonSpacing,
        endIndent: commonSpacing,
        height: dividerHeight,
      );
}
