import 'package:flutter/material.dart';

import '../../mocks.dart';
import '../../utils/num_ext.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/card_list.dart';
import '../widget/short_app_bar.dart';
import '../widget/sight_card.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const maxDistance = 30000.0;
  RangeValues distance = const RangeValues(0, 10000);
  RangeValues values = const RangeValues(0, 43);

  @override
  Widget build(BuildContext context) {
    final maxValue = _distanceToValue(maxDistance);

    return Scaffold(
      appBar: const ShortAppBar(
        title: filtersScreenTitle,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // const Text('Категории'), // временно
          // const Text('...'), // временно
          // const SizedBox(
          //   height: MyThemeData.filtersSectionSpacing,
          // ),
          Padding(
            padding: MyThemeData.commonPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filtersScreenDistance,
                  style: Theme.of(context).primaryTextTheme.headline6,
                ),
                Text(
                  _distanceToString(distance),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          RangeSlider(
            values: _distanceToValues(distance),
            divisions: maxValue.round(),
            onChanged: (values) {
              if (values.start.round() >= values.end.round()) return;
              setState(() {
                distance = _valuesToDistance(values);
              });
              print(
                  '[${values.start.round()}..${values.end.round()}] - $distance');
            },
            min: 0,
            max: maxValue,
          ),
          Expanded(
            child: CardList(
              iterable: mocks.where((element) {
                final distance = element.coord.distance(myMockCoord);
                return distance.value >= this.distance.start &&
                    distance.value <= this.distance.end;
              }).toList()
                ..sort((a, b) => a.coord
                    .distance(myMockCoord)
                    .compareTo(b.coord.distance(myMockCoord))),
              cardType: SightCardType.list,
            ),
          ),
        ],
      ),
    );
  }

  // Переводит расстояние в значение слайдера.
  double _distanceToValue(double distance) {
    //  0..10: от 0 до 1 км каждые 100 м;
    // 10..14: от 1 км до 3 км каждые 500 м;
    // 14..nn: далее по 1 км.
    if (distance <= 1000) {
      return (distance / 100).round().toDouble();
    } else if (distance <= 3000) {
      return ((distance - 1000) / 500).round() + 10;
    } else {
      return ((distance - 3000) / 1000).round() + 14;
    }
  }

  // Переводит значение слайдера в расстояние.
  double _valueToDistance(double value) {
    if (value <= 10) {
      return value * 100;
    } else if (value <= 14) {
      return 1000 + (value - 10) * 500;
    } else {
      return 3000 + (value - 14) * 1000;
    }
  }

  // Переводит диапазон расстояний в диапазон значений слайдера.
  RangeValues _distanceToValues(RangeValues distance) => RangeValues(
        _distanceToValue(distance.start),
        _distanceToValue(distance.end),
      );

  // Переводит диапазон значений слайдера в диапазон расстояний.
  RangeValues _valuesToDistance(RangeValues values) => RangeValues(
        _valueToDistance(values.start),
        _valueToDistance(values.end),
      );

  // Переводит диапазон расстояний в строку.
  String _distanceToString(RangeValues distance) {
    String start;
    bool endInMeters;
    String endValue;
    String endUnits;

    if (distance.end < 1000) {
      endInMeters = true;
      endUnits = meters;
      endValue = distance.end.toStringAsFixed(0);
    } else {
      endInMeters = false;
      endUnits = kilometers;
      endValue = (distance.end / 1000).toStringAsFixedWithoutTrailingZeros(1);
    }

    if (distance.start.round() == 0) {
      start = '';
    } else if (distance.start < 1000) {
      start = '$rangeFrom '
          '${distance.start.toStringAsFixed(0)}'
          '${endInMeters ? '' : ' $meters'} ';
    } else {
      start = '$rangeFrom '
          '${(distance.start / 1000).toStringAsFixedWithoutTrailingZeros(1)}'
          '${endInMeters ? ' $kilometers' : ''} ';
    }

    return '$start$rangeTo $endValue $endUnits';
  }
}
