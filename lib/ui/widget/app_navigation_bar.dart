import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';

import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/map_screen.dart';
import 'package:places/ui/screen/place_list_screen.dart';
import 'package:places/ui/screen/settings_screen.dart';
import 'package:places/ui/screen/favorite_screen.dart';

/// BottomNavigator приложения.
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  /// Текущая позиция.
  final int index;

  void _goto(BuildContext context, Widget Function() page) {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute(
        builder: (context) => page(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        switch (index) {
          case 0:
            // Список интересных мест.
            _goto(context, () => PlaceListScreen());
            break;

          case 1:
            // Карта.
            _goto(context, () => MapScreen());
            break;

          case 2:
            // Хочу посетить/Посетил.
            _goto(context, () => FavoriteScreen());
            break;

          case 3:
            // Настройки.
            _goto(context, () => SettingsScreen());
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            index == 0 ? Svg24.listFull : Svg24.list,
            color: _itemColor(theme, index == 0),
          ),
          label: stringPlaceList,
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            index == 1 ? Svg24.mapFull : Svg24.map,
            color: _itemColor(theme, index == 1),
          ),
          label: stringMap,
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
