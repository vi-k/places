import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app_bloc.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/svg.dart';

/// Виджет типа места.
class PlaceTypeFilter extends StatelessWidget {
  PlaceTypeFilter({
    Key? key,
    required PlaceType placeType,
    required this.active,
    required this.onPressed,
  })   : placeTypeUi = PlaceTypeUi(placeType),
        super(key: key);

  /// Тип места.
  final PlaceTypeUi placeTypeUi;

  /// Активен тип?
  ///
  /// Флажок справа, что именно этот тип сейчас установлен.
  final bool active;

  /// Обратный вызов при нажатии.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Container(
      margin: commonPadding,
      width: filtersPlaceTypeSize,
      child: Column(
        children: [
          SizedBox(
            height: filtersPlaceTypeSize,
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
                        placeTypeUi.svg,
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
            placeTypeUi.name,
            textAlign: TextAlign.center,
            style: theme.textRegular12Main,
          ),
        ],
      ),
    );
  }
}
