/// Виджет: Поле поиска.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/strings.dart';
import '../res/themes.dart';
import '../screen/filters_screen.dart';
import 'my_theme.dart';
import 'svg_button.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key, this.onTap}) : super(key: key);

  final void Function()? onTap;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var _filterStarted = false;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Ink(
      decoration: BoxDecoration(
        color: theme.backgroundSecond,
        borderRadius: BorderRadius.circular(MyThemeData.textFieldRadius),
      ),
      child: TextField(
        readOnly: true,
        onTap: () {
          if (!_filterStarted) widget.onTap?.call();
        },
        decoration: InputDecoration(
          prefixIcon: UnconstrainedBox(
            child: SvgPicture.asset(
              assetSearch,
              color: theme.lightTextColor56,
            ),
          ),
          suffixIcon: UnconstrainedBox(
            child: SvgButton(
              svg: assetFilter,
              color: theme.accentColor,
              onPressed: () {
                _filterStarted = true;
                Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FiltersScreen(),
                    )).then((value) {
                  setState(() {
                    _filterStarted = false;
                  });
                });
              },
            ),
          ),
          hintText: stringSearch,
          enabledBorder: theme.app.inputDecorationTheme.enabledBorder?.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: theme.app.inputDecorationTheme.enabledBorder?.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
        ),
      ),
    );
  }
}
