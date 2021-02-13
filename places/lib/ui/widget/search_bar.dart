import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/repository/base/filter.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screen/filters_screen.dart';

import 'svg_button.dart';

/// Поле поиска.
class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    this.onTap,
    required this.filter,
    required this.onChanged,
  }) : super(key: key);

  /// Обратный вызов при нажатии на поле.
  ///
  /// Если не `null`, поле становится недоступно для ввода, на него только
  /// можно нажать.
  final void Function()? onTap;

  /// Фильтр.
  final Filter filter;

  /// Обратный вызов при изменении фильтра.
  final void Function(Filter filter) onChanged;

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
                readOnly: onTap != null,
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
              if (onTap != null)
                Positioned.fill(
                  child: InkWell(
                    onTap: onTap,
                  ),
                ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: SvgButton(
                  Svg24.filter,
                  color: theme.accentColor,
                  onPressed: () async {
                    final newFilter = await Navigator.push<Filter>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FiltersScreen(filter: filter),
                      ),
                    );

                    if (newFilter != null) onChanged(newFilter);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
