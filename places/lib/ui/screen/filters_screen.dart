import 'package:flutter/material.dart';
import 'package:places/data/model/place_type.dart';

import 'package:places/data/repository/base/filter.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/section.dart';
import 'package:places/ui/widget/place_type_filter.dart';
import 'package:places/ui/widget/small_app_bar.dart';
import 'package:places/ui/widget/standart_button.dart';
import 'package:places/utils/distance.dart';
import 'package:places/utils/let_and_also.dart';

import 'utils/distance_utils.dart';

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
  late Filter _filter;
  int? _cardCount;

  Filter get filter => _filter;
  set filter(Filter value) {
    _filter = value;
    _cardCount = null;
    _recalcCardCount();
  }

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.height <= 800;

    return Scaffold(
      appBar: SmallAppBar(
        title: stringFilter,
        button: stringClear,
        onPressed: () {
          setState(() {
            filter = Filter();
          });
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                ..._buildCategories(isSmallScreen),
                const SizedBox(height: commonSpacing),
                ..._buildDistance(theme),
                const SizedBox(height: commonSpacing),
              ],
            ),
          ),
          Padding(
            padding: commonPadding,
            child: StandartButton(
              label:
                  stringApply + (_cardCount?.let((it) => ' ($it)') ?? ' ...'),
              onPressed: () => Navigator.pop(context, filter),
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
                filter.radius.toString(),
                style: theme.textRegular16Light,
              ),
            ],
          ),
        ),
        Slider(
          min: 1,
          max: _maxValue,
          value: filter.radius.isInfinite
              ? _maxValue
              : distanceToValue(filter.radius).toDouble(),
          onChanged: (value) {
            setState(() {
              filter = filter.copyWith(
                  radius: value.roundToDouble() == _maxValue
                      ? Distance.infinity
                      : valueToDistance(value.round()));
            });
          },
        ),
      ];

  List<Widget> _buildCategories(bool isSmallScreen) => [
        Section(
          stringCategories,
          child: isSmallScreen
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildCategoriesItems(),
                  ),
                )
              : Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: _buildCategoriesItems(),
                ),
        ),
      ];

  List<Widget> _buildCategoriesItems() => [
        for (final placeType in PlaceType.values)
          PlaceTypeFilter(
            placeType: placeType,
            active: filter.hasPlaceType(placeType),
            onPressed: () {
              setState(() {
                filter = filter.togglePlaceType(placeType);
              });
            },
          ),
      ];

  Future<void> _recalcCardCount() async {
    // Пока реально это не ассинхронная функция.
    // placeInteractor.getPlaces();
    // final count = Mocks.of(context).sights.where((e) {
    //   if (!filter.hasCategory(e.categoryId)) return false;

    //   final d = e.coord.distance(myMockCoord);
    //   return d >= filter.distance.start && d <= filter.distance.end;
    // }).length;

    // setState(() {
    //   _cardCount = count;
    // });
  }
}
