import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../../translate.dart';
import '../res/strings.dart';
import '../res/themes.dart';

class SightTypeFilter extends StatelessWidget {
  const SightTypeFilter({
    Key? key,
    required this.type,
    required this.active,
    required this.onPressed,
  }) : super(key: key);

  final SightType type;
  final bool active;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => Container(
        margin: MyThemeData.commonPadding,
        width: MyThemeData.filtersCategorySize,
        child: Column(
          children: [
            SizedBox(
              height: MyThemeData.filtersCategorySize,
              child: Stack(
                children: [
                  Material(
                    type: MaterialType.transparency,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: Ink(
                      color: active
                          ? MyThemeData.categoryBackground
                          : Colors.transparent,
                      child: InkWell(
                        onTap: onPressed,
                        child: Center(
                          child: SvgPicture.asset(
                            assetForSightType(type),
                            color: active
                                ? MyThemeData.categoryActiveColor
                                : MyThemeData.categoryInactiveColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (active)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SvgPicture.asset(assetChoice),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: MyThemeData.filtersCategorySpacing,
            ),
            Text(
              translate(type.toString()),
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
          ],
        ),
      );
}
