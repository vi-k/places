import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../res/const.dart';
import '../res/svg.dart';
import '../res/themes.dart';

/// Виджет: категория места.
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
      margin: commonPadding,
      width: filtersCategorySize,
      child: Column(
        children: [
          SizedBox(
            height: filtersCategorySize,
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
                      width: tickChoiceSize,
                      height: tickChoiceSize,
                      decoration: BoxDecoration(
                        color: theme.mainTextColor2,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Svg24.tick,
                          color: theme.inverseTextColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: commonSpacing1_2),
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
