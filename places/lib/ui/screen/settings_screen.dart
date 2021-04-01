import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/utils/animation.dart';
import 'package:places/ui/widget/app_navigation_bar.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:provider/provider.dart';

import 'onboarding_screen.dart';

/// Экран настроек.
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Scaffold(
      appBar: const SmallAppBar(
        title: stringSettings,
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => ListView(
          children: [
            SwitchListTile(
              title: Text(
                stringIsDark,
                style: theme.textRegular14Main,
              ),
              value: context.watch<AppBloc>().settings.isDark,
              onChanged: (value) {
                context.read<AppBloc>().add(AppChangeSettings(isDark: value));
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
              onTap: () => standartNavigatorPush<void>(
                  context, () => OnboardingScreen()),
            ),
            const _ListDivider(),
          ],
        ),
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
