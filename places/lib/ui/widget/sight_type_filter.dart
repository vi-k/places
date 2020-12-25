/// Виджет: категория места.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import 'my_theme.dart';

class SightCategoryFilter extends StatelessWidget {
  const SightCategoryFilter({
    Key? key,
    required this.category,
    required this.active,
    required this.onPressed,
  }) : super(key: key);

  final SightCategory category;
  final bool active;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Container(
      margin: MyThemeData.commonPadding,
      width: MyThemeData.filtersCategorySize,
      child: Column(
        children: [
          SizedBox(
            height: MyThemeData.filtersCategorySize,
            child: Stack(
              children: [
                Material(
                  type: MaterialType.circle,
                  clipBehavior: Clip.antiAlias,
                  color: theme.accentColor16,
                  child: InkWell(
                    onTap: onPressed,
                    child: Center(
                      child: SvgPicture.asset(
                        category.asset,
                        color: theme.accentColor,
                      ),
                    ),
                  ),
                ),
                if (active)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.mainTextColor2,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          assetTickChoice,
                          color: theme.inverseTextColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: MyThemeData.filtersCategorySpacing,
          ),
          Text(
            category.text,
            textAlign: TextAlign.center,
            style: theme.textRegular12Main,
          ),
        ],
      ),
    );
  }
}
