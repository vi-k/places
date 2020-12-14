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
  Widget build(BuildContext context) => Container(
        height: smallButtonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tabsSwitchRadius),
          color: tabsBackground,
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
                      ? textColorPrimary
                      : Colors.transparent,
                  label: Text(
                    tabs[i],
                    style: i == tabController.index
                        ? textBoldWhite
                        : textBoldSecondary,
                  ),
                ),
              ),
          ],
        ),
      );
}
