import 'package:flutter/material.dart';

import '../../domain/category.dart';
import '../../domain/filter.dart';
import '../../domain/mocks_data.dart';
import '../../utils/maps.dart';
import '../../utils/range.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/mocks.dart';
import '../widget/section.dart';
import '../widget/sight_type_filter.dart';
import '../widget/small_app_bar.dart';
import '../widget/standart_button.dart';

/// Экран настроек фильтра.
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
    _recalcCardCount();
  }

  @override
  void initState() {
    super.initState();
    filter = Filter();
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
              label: stringApply +
                  (_cardCount == null ? ' ...' : ' ($_cardCount)'),
              onPressed: () => print('Apply filter'),
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
                _distanceToString(filter.distance),
                style: theme.textRegular16Light,
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
            //print('[${values.start}..${values.end}] - ${filter.distance}');
          },
          min: 0,
          max: _distanceToValue(_maxDistance).toDouble(),
        ),
      ];

  List<Widget> _buildCategories(bool isSmallScreen) => [
        Section(
          stringCategories,
          child: FutureBuilder<List<Category>>(
            future: Mocks.of(context, listen: true).categories,
            builder: (context, snapshot) => !snapshot.hasData
                ? const Text('Loading')
                : isSmallScreen
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildCategoryItems(snapshot.data!),
                        ),
                      )
                    : Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: _buildCategoryItems(snapshot.data!),
                      ),
          ),
        ),
      ];

  List<Widget> _buildCategoryItems(List<Category> data) => [
        for (final category in data)
          SightCategoryFilter(
            category: category,
            active: filter.hasCategory(category.id),
            onPressed: () {
              setState(() {
                filter = filter.toggleCategory(category.id);
              });
            },
          ),
      ];

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
      prefix = '$stringRangeFrom '
          '${distance.start.toString(withUnits: withUnits)} ';
    }

    return '$prefix$stringRangeTo $endValue';
  }

  Future<void> _recalcCardCount() async {
    // Пока реально это не ассинхронная функция.
    final count = Mocks.of(context).sights.where((e) {
      if (!filter.hasCategory(e.categoryId)) return false;

      final d = e.coord.distance(myMockCoord);
      return d >= filter.distance.start && d <= filter.distance.end;
    }).length;

    setState(() {
      _cardCount = count;
    });
  }
}
