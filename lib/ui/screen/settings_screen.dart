import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
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
  static const _sliderValues = [0, 100, 200, 300, 500, 1000, 1500, 2000, 3000];

  AppBloc get appBloc => context.read<AppBloc>();

  late MyThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = context.watch<AppBloc>().theme;

    return Scaffold(
      appBar: const SmallAppBar(
        title: stringSettings,
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => ListView(
          children: [
            _buildSectionIsDark(state.settings.value.isDark),
            const _ListDivider(),
            _buildSectionTutorial(),
            const _ListDivider(),
            _buildSectionShowTutorialOnNextStartup(
              state.settings.value.showTutorial,
            ),
            const _ListDivider(),
            _buildAnimationDuration(state.settings.value.animationDuration),
            const _ListDivider(),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(index: 3),
    );
  }

  Widget _buildAnimationDuration(int animationDuration) => ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stringAnimationDuration,
              style: _theme.textRegular14Main,
            ),
            Text(
              '$animationDuration мс',
              style: _theme.textRegular14Accent,
            ),
          ],
        ),
        subtitle: Slider(
          min: 0,
          max: _sliderValues.length - 1,
          divisions: _sliderValues.length - 1,
          value: _valueToSlider(animationDuration),
          onChanged: (value) => appBloc.add(
            AppSettingsChanged(
              animationDuration: _sliderToValue(value),
            ),
          ),
        ),
      );

  Widget _buildSectionShowTutorialOnNextStartup(bool showTutorial) =>
      SwitchListTile(
        title: Text(
          stringShowTutorialOnNextStartup,
          style: _theme.textRegular14Main,
        ),
        value: showTutorial,
        onChanged: (value) =>
            appBloc.add(AppSettingsChanged(showTutorial: value)),
      );

  Widget _buildSectionTutorial() => ListTile(
        title: Text(
          stringWatchTutorial,
          style: _theme.textRegular14Main,
        ),
        trailing: Icon(
          Icons.info_outline,
          color: _theme.accentColor,
        ),
        onTap: () => standartNavigatorPush<void>(
          context,
          () => OnboardingScreen(),
        ),
      );

  Widget _buildSectionIsDark(bool isDark) => SwitchListTile(
        title: Text(
          stringIsDark,
          style: _theme.textRegular14Main,
        ),
        value: isDark,
        onChanged: (value) => appBloc.add(AppSettingsChanged(isDark: value)),
      );

  double _valueToSlider(int value) {
    for (final e in _sliderValues.asMap().entries) {
      if (e.value == value) return e.key.toDouble();
    }

    return 200;
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
