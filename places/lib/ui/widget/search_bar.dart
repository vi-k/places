import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../screen/filters_screen.dart';
import 'svg_button.dart';

/// Поле поиска.
class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.onTap,
  }) : super(key: key);

  /// Обратный вызов при нажатии на поле.
  ///
  /// Если не `null`, поле становится недоступно для ввода, на него только
  /// можно нажать.
  final void Function()? onTap;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Stack(
      children: [
        Material(
          color: theme.backgroundSecond,
          borderRadius: BorderRadius.circular(searchFieldRadius),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              TextFormField(
                autofocus: true,
                readOnly: widget.onTap != null,
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints.tightFor(
                    height: smallButtonHeight,
                    width: smallButtonHeight,
                  ),
                  prefixIcon: UnconstrainedBox(
                    child: SvgPicture.asset(
                      Svg24.search,
                      color: theme.lightTextColor56,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints.tightFor(
                    height: smallButtonHeight,
                    width: smallButtonHeight,
                  ),
                  suffixIcon: const SizedBox(),
                  hintText: stringSearch,
                  enabledBorder: theme.app.inputDecorationTheme.enabledBorder
                      ?.copyWith(
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                  focusedBorder: theme.app.inputDecorationTheme.enabledBorder
                      ?.copyWith(
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                ),
              ),
              if (widget.onTap != null)
                Positioned.fill(
                  child: InkWell(
                    onTap: widget.onTap,
                  ),
                ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: SvgButton(
                  Svg24.filter,
                  color: theme.accentColor,
                  onPressed: () {
                    Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FiltersScreen(),
                        )).then((value) {
                      setState(() {});
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
