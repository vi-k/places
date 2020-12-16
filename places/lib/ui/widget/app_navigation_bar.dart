import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/strings.dart';
import '../screen/sight_list_screen.dart';
import '../screen/visiting_screen.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SightListScreen(),
                  ));
              break;

            case 2:
              Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitingScreen(),
                  ));
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              index == 0 ? assetListFull : assetList,
              color: _itemColor(context, index == 0),
            ),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              index == 1 ? assetMapFull : assetMap,
              color: _itemColor(context, index == 1),
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              index == 2 ? assetFavoriteFull : assetFavorite,
              color: _itemColor(context, index == 2),
            ),
            label: 'Visiting',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              index == 3 ? assetSettingsFull : assetSettings,
              color: _itemColor(context, index == 3),
            ),
            label: 'Settings',
          ),
        ],
      );

  Color? _itemColor(BuildContext context, bool selected) => selected
      ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
      : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
}
