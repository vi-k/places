import 'package:places/utils/distance.dart';

/// Переводит расстояние в значение слайдера.
int distanceToValue(Distance distance) {
  //  0..10: от 0 до 1 км каждые 100 м;
  // 10..14: от 1 км до 3 км каждые 500 м;
  // 14..41: от 3 км до 30 км каждый 1 км;
  // 41..nn: далее по 5 км.
  if (distance.value <= 1000) {
    return (distance.value / 100).round();
  } else if (distance.value <= 3000) {
    return ((distance.value - 1000) / 500).round() + 10;
  } else if (distance.value <= 30000) {
    return ((distance.value - 3000) / 1000).round() + 14;
  } else {
    return ((distance.value - 30000) / 5000).round() + 41;
  }
}

/// Переводит значение слайдера в расстояние.
Distance valueToDistance(int value) {
  double distance;

  if (value <= 10) {
    distance = value * 100;
  } else if (value <= 14) {
    distance = 1000 + (value - 10) * 500;
  } else if (value <= 41) {
    distance = 3000 + (value - 14) * 1000;
  } else {
    distance = 30000 + (value - 41) * 5000;
  }

  return Distance(distance);
}
