import 'package:flutter/material.dart';

import '../res/const.dart';
import 'my_theme.dart';
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
  Widget build(BuildContext context) => Container(
        height: smallButtonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tabsSwitchRadius),
          color: MyTheme.of(context).tabSwitchInactiveColor,
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
                      ? MyTheme.of(context).tabSwitchActiveColor
                      : Colors.transparent,
                  label: tabs[i],
                  style: i == tabController.index
                      ? MyTheme.of(context).tabSwitchActiveTextStyle
                      : MyTheme.of(context).tabSwitchInactiveTextStyle,
                ),
              ),
          ],
        ),
      );
}
