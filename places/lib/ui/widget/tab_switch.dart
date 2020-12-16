import 'package:flutter/material.dart';

import '../res/colors.dart';
import '../res/const.dart';
import '../res/text_styles.dart';
import 'small_button.dart';

class TabSwitch extends StatelessWidget {
  const TabSwitch({
    Key? key,
    required this.tabs,
    required this.tabController,
  }) : super(key: key);

  final List<String> tabs;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: smallButtonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(tabsSwitchRadius),
        color: Theme.of(context).cardTheme.color,
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
                    ? (isDark
                        ? darkTextPrimaryColor
                        : lightTextPrimaryColor)
                    : Colors.transparent,
                label: tabs[i],
                style: Theme.of(context).primaryTextTheme.bodyText1?.copyWith(
                    color: i == tabController.index
                        ? (isDark
                            ? lightTextPrimaryColor
                            : darkTextPrimaryColor)
                        : (isDark
                            ? darkTextSecondaryColor
                            : lightTextSecondaryColor)),
              ),
            ),
        ],
      ),
    );
  }
}
