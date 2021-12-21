import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/model/place_type_ui.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';

/// Виджет типа места.
class PlaceTypeFilter extends StatefulWidget {
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
  _PlaceTypeFilterState createState() => _PlaceTypeFilterState();
}

class _PlaceTypeFilterState extends State<PlaceTypeFilter> {
  late MyThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = context.watch<AppBloc>().theme;

    return Container(
      margin: commonPadding,
      width: filtersPlaceTypeSize,
      child: Column(
        children: [
          _buildImage(),
          const SizedBox(height: commonSpacing1_2),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildText() => Text(
        widget.placeTypeUi.name,
        textAlign: TextAlign.center,
        style: _theme.textRegular12Main,
      );

  Widget _buildImage() => SizedBox(
        height: filtersPlaceTypeSize,
        child: Stack(
          children: [
            _buildButton(),
            if (widget.active) _buildTick(),
          ],
        ),
      );

  Widget _buildTick() => Align(
        alignment: Alignment.bottomRight,
        child: Container(
          width: tickChoiceSize,
          height: tickChoiceSize,
          decoration: BoxDecoration(
            color: _theme.mainTextColor2,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              Svg24.tick,
              color: _theme.inverseTextColor,
            ),
          ),
        ),
      );

  Widget _buildButton() => Material(
        type: MaterialType.circle,
        clipBehavior: Clip.antiAlias,
        color: _theme.accentColor16,
        child: InkWell(
          onTap: widget.onPressed,
          child: Center(
            child: SvgPicture.asset(
              widget.placeTypeUi.svg,
              color: _theme.accentColor,
            ),
          ),
        ),
      );
}
