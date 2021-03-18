import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app_bloc.dart';

import 'package:places/ui/res/const.dart';

import 'package:places/ui/res/themes.dart';
import 'small_button.dart';

/// Переключатель табов.
///
/// Состоит из трёх слоёв:
/// 1. Подложка с названиями табов.
/// 2. Перемещаемый ползунок.
/// 3. Кнопки.
class TabSwitch extends StatelessWidget {
  const TabSwitch({
    Key? key,
    required this.tabs,
    required this.tabController,
  }) : super(key: key);

  static const _maxFlex = 1000000;

  /// Список названий табов.
  final List<String> tabs;

  /// Контроллер табов.
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Container(
      height: smallButtonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(tabsSwitchRadius),
        color: theme.backgroundSecond,
      ),
      child: Stack(
        children: [
          _buildBottom(theme),
          _buildThumb(theme),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildBottom(MyThemeData theme) => Positioned.fill(
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: Text(
                  tabs[i],
                  style: theme.textBold14Light,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      );

  Widget _buildThumb(MyThemeData theme) {
    final thumbSize = _maxFlex ~/ tabs.length;

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: tabController.animation!,
        builder: (context, child) {
          final animValue = tabController.animation!.value;
          final indent =
              ((_maxFlex - thumbSize) * animValue / (tabs.length - 1)).round();
          final tabIndex = animValue.round();
          final opacity = 1.0 - 2 * (animValue - tabIndex).abs();

          return Row(
            children: [
              Flexible(
                flex: indent,
                fit: FlexFit.tight,
                child: const SizedBox(),
              ),
              Flexible(
                flex: thumbSize,
                fit: FlexFit.tight,
                child: Container(
                  height: smallButtonHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tabsSwitchRadius),
                    color: theme.mainTextColor,
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: opacity,
                      child: Text(
                        tabs[tabIndex],
                        style: theme.textBold14Light,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: _maxFlex - thumbSize - indent,
                fit: FlexFit.tight,
                child: const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButtons() => Positioned.fill(
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: SmallButton(
                  onPressed: () {
                    tabController.animateTo(i);
                  },
                  color: Colors.transparent,
                  label: '',
                ),
              ),
          ],
        ),
      );
}
