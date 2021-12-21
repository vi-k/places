import 'package:flutter/material.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/data/model/filter.dart';
import 'package:places/data/model/place_type.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/utils/distance_utils.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/place_type_filter.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/standart_button.dart';
import 'package:places/utils/distance.dart';
import 'package:provider/provider.dart';

/// Экран настроек фильтра.
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({
    Key? key,
    required this.filter,
  }) : super(key: key);

  final Filter filter;

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const _maxDistance = Distance.km(100);
  static final _maxValue = distanceToValue(_maxDistance).toDouble() + 1;
  late Filter _filter = widget.filter;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Scaffold(
      appBar: SmallAppBar(
        title: stringFilter,
        button: stringClear,
        onPressed: () {
          setState(() {
            _filter = Filter();
          });
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                ..._buildPlaceTypes(),
                const SizedBox(height: commonSpacing),
                ..._buildDistance(theme),
                const SizedBox(height: commonSpacing),
              ],
            ),
          ),
          Padding(
            padding: commonPadding,
            child: StandartButton(
              label: stringApply,
              onPressed: () => Navigator.pop(context, _filter),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDistance(MyThemeData theme) => [
        Padding(
          padding: commonPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stringDistance,
                style: theme.textRegular16Main,
              ),
              Text(
                _filter.radius.toString(),
                style: theme.textRegular16Light,
              ),
            ],
          ),
        ),
        Slider(
          min: 1,
          max: _maxValue,
          value: _filter.radius.isInfinite
              ? _maxValue
              : distanceToValue(_filter.radius).toDouble(),
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(
                radius: value.roundToDouble() == _maxValue
                    ? Distance.infinity
                    : valueToDistance(value.round()),
              );
            });
          },
        ),
      ];

  List<Widget> _buildPlaceTypes() => [
        Section(
          stringPlaceTypes,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: _buildPlaceTypesItems(),
          ),
        ),
      ];

  List<Widget> _buildPlaceTypesItems() => [
        for (final placeType in PlaceType.values)
          PlaceTypeFilter(
            placeType: placeType,
            active: _filter.hasPlaceType(placeType),
            onPressed: () {
              setState(() {
                _filter = _filter.togglePlaceType(placeType);
              });
            },
          ),
      ];
}
