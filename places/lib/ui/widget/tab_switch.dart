import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app_bloc.dart';

import 'package:places/ui/res/const.dart';

import 'small_button.dart';

/// Переключатель табов.
class TabSwitch extends StatelessWidget {
  const TabSwitch({
    Key? key,
    required this.tabs,
    required this.tabController,
  }) : super(key: key);

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
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: SmallButton(
                onPressed: () {
                  tabController.index = i;
                },
                color: i == tabController.index
                    ? theme.mainTextColor
                    : Colors.transparent,
                label: tabs[i],
                style: i == tabController.index
                    ? theme.textBold14Inverse
                    : theme.textBold14Light,
              ),
            ),
        ],
      ),
    );
  }
}
