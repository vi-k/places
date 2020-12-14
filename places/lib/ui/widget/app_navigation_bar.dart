import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/colors.dart';
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
              color: textColorPrimary,
            ),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              index == 1 ? assetMapFull : assetMap,
              color: textColorPrimary,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              index == 2 ? assetFavoriteFull : assetFavorite,
              color: textColorPrimary,
            ),
            label: 'Visiting',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              index == 3 ? assetSettingsFull : assetSettings,
              color: textColorPrimary,
            ),
            label: 'Settings',
          ),
        ],
      );
}
