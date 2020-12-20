import 'package:flutter/material.dart';

import '../../domain/filter.dart';
import '../../domain/sight.dart';
import '../../mocks.dart';
import '../../utils/maps.dart';
import '../../utils/range.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/short_app_bar.dart';
import '../widget/sight_type_filter.dart';
import '../widget/small_button.dart';
import '../widget/standart_button.dart';
import '../widget/svg_button.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const _maxDistance = Distance(30000);
  late Filter _filter;
  int? _cardCount;

  Filter get filter => _filter;
  set filter(Filter value) {
    _filter = value;
    _cardCount = null;
    calcCardCount().then((value) => setState(() {
          _cardCount = value;
        }));
  }

  @override
  void initState() {
    super.initState();
    filter = Filter();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._buildCategories(),
              const SizedBox(height: MyThemeData.filtersSectionSpacing),
              ..._buildDistance(context),
              const SizedBox(height: MyThemeData.filtersSectionSpacing),
              Padding(
                padding: MyThemeData.commonPadding,
                child: StandartButton(
                  label: filtersApply +
                      (_cardCount == null ? ' ...' : ' ($_cardCount)'),
                  onPressed: () {
                    print('Apply filter');
                  },
                ),
              ),
            ],
          ),
        ),
      );

  List<Widget> _buildDistance(BuildContext context) => [
        Padding(
          padding: MyThemeData.commonPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                filtersDistance,
                style: Theme.of(context).primaryTextTheme.headline5,
              ),
              Text(
                _distanceToString(filter.distance),
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
        RangeSlider(
          values: _distanceToValues(filter.distance),
          onChanged: (values) {
            if (values.start.round() >= values.end.round()) return;
            setState(() {
              filter = filter.copyWith(distance: _valuesToDistance(values));
            });
            print('[${values.start}..${values.end}] - ${filter.distance}');
          },
          min: 0,
          max: _distanceToValue(_maxDistance).toDouble(),
        ),
      ];

  List<Widget> _buildCategories() => [
        Padding(
          padding: MyThemeData.filtersCaptionPadding,
          child: const Text(filtersCategories),
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            for (final type in SightType.values)
              SightTypeFilter(
                type: type,
                active: filter.hasCategory(type),
                onPressed: () {
                  setState(() {
                    filter = filter.toggleCategory(type);
                  });
                },
              ),
          ],
        ),
      ];

  PreferredSizeWidget _buildAppBar(BuildContext context) => ShortAppBar(
        padding: MyThemeData.appBarFiltersPadding,
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgButton(
              onPressed: () {
                print('Back');
              },
              svg: assetBack,
              color: Theme.of(context).primaryColor,
            ),
            SmallButton(
              onPressed: () {
                setState(() {
                  filter = Filter();
                });
              },
              label: filtersClear,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: MyThemeData.buttonColor),
            ),
          ],
        ),
      );

  // Переводит расстояние в значение слайдера.
  int _distanceToValue(Distance distance) {
    //  0..10: от 0 до 1 км каждые 100 м;
    // 10..14: от 1 км до 3 км каждые 500 м;
    // 14..nn: далее по 1 км.
    if (distance.value <= 1000) {
      return (distance.value / 100).round();
    } else if (distance.value <= 3000) {
      return ((distance.value - 1000) / 500).round() + 10;
    } else {
      return ((distance.value - 3000) / 1000).round() + 14;
    }
  }

  // Переводит значение слайдера в расстояние.
  Distance _valueToDistance(int value) {
    double distance;

    if (value <= 10) {
      distance = value * 100;
    } else if (value <= 14) {
      distance = 1000 + (value - 10) * 500;
    } else {
      distance = 3000 + (value - 14) * 1000;
    }

    return Distance(distance);
  }

  // Переводит диапазон расстояний в диапазон значений слайдера.
  RangeValues _distanceToValues(Range<Distance> distance) => RangeValues(
        _distanceToValue(distance.start).toDouble(),
        _distanceToValue(distance.end).toDouble(),
      );

  // Переводит диапазон значений слайдера в диапазон расстояний.
  Range<Distance> _valuesToDistance(RangeValues values) => Range<Distance>(
        _valueToDistance(values.start.round()),
        _valueToDistance(values.end.round()),
      );

  // Переводит диапазон расстояний в строку.
  String _distanceToString(Range<Distance> distance) {
    String prefix;
    final endUnits = distance.end.optimalUnits;
    final endValue = distance.end.toString(units: endUnits);

    if (distance.start.value.round() == 0) {
      prefix = '';
    } else {
      final withUnits = distance.start.optimalUnits != endUnits;
      prefix = '$rangeFrom '
          '${distance.start.toString(withUnits: withUnits)} ';
    }

    return '$prefix$rangeTo $endValue';
  }

  Future<int> calcCardCount() async => mocks.where((element) {
        if (!filter.hasCategory(element.type)) return false;

        final d = element.coord.distance(myMockCoord);
        return d >= filter.distance.start && d <= filter.distance.end;
      }).length;
}
