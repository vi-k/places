import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../screen/settings_screen.dart';
import '../screen/sight_list_screen.dart';
import '../screen/visiting_screen.dart';

/// BottomNavigator приложения.
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  /// Текущая позиция.
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return BottomNavigationBar(
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

          case 1:
            break;

          case 2:
            Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute(
                  builder: (context) => VisitingScreen(),
                ));
            break;

          case 3:
            Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ));
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            index == 0 ? Svg24.listFull : Svg24.list,
            color: _itemColor(theme, index == 0),
          ),
          label: stringSightList,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            index == 1 ? Svg24.mapFull : Svg24.map,
            color: _itemColor(theme, index == 1),
          ),
          label: 'Map', // Временно
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            index == 2 ? Svg24.heartFull : Svg24.heart,
            color: _itemColor(theme, index == 2),
          ),
          label: stringFavorite,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            index == 3 ? Svg24.settingsFull : Svg24.settings,
            color: _itemColor(theme, index == 3),
          ),
          label: stringSettings,
        ),
      ],
    );
  }

  Color? _itemColor(MyThemeData theme, bool selected) => selected
      ? theme.app.bottomNavigationBarTheme.selectedItemColor
      : theme.app.bottomNavigationBarTheme.unselectedItemColor;
}
