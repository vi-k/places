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
  AppBloc get appBloc => context.read<AppBloc>();

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
              value: state.settings.value.isDark,
              onChanged: (value) =>
                  appBloc.add(AppChangeSettings(isDark: value)),
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
            SwitchListTile(
              title: Text(
                stringShowTutorialOnNextStartup,
                style: theme.textRegular14Main,
              ),
              value: state.settings.value.showTutorial,
              onChanged: (value) =>
                  appBloc.add(AppChangeSettings(showTutorial: value)),
            ),
            const _ListDivider(),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stringAnimationDuration,
                    style: theme.textRegular14Main,
                  ),
                  Text(
                    '${state.settings.value.animationDuration} мс',
                    style: theme.textRegular14Accent,
                  ),
                ],
              ),
              subtitle: Slider(
                min: 0,
                max: _sliderValues.length - 1,
                divisions: _sliderValues.length - 1,
                value: _valueToSlider(state.settings.value.animationDuration),
                onChanged: (value) => appBloc.add(AppChangeSettings(
                    animationDuration: _sliderToValue(value))),
              ),
            ),
            const _ListDivider(),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(index: 3),
    );
  }

  final _sliderValues = [0, 100, 200, 300, 500, 1000, 1500, 2000, 3000];

  double _valueToSlider(int value) {
    for (final e in _sliderValues.asMap().entries) {
      if (e.value == value) return e.key.toDouble();
    }
    return 250;
  }

  int _sliderToValue(double slider) => _sliderValues[slider.round()];
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
