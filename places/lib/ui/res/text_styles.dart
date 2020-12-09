import 'package:flutter/material.dart';

import 'colors.dart';
import 'const.dart';

const TextStyle _normalTextStyle = TextStyle(
  fontSize: 14,
  height: 18 / 14,
  color: mainFontColor,
  fontWeight: FontWeight.normal,
);

final TextStyle _boldTextStyle = _normalTextStyle.copyWith(
  fontWeight: FontWeight.bold,
);

final TextStyle appbarTextStyle = _boldTextStyle.copyWith(
  fontSize: appbarFontSize,
  height: appbarLineMultiplier,
  fontWeight: FontWeight.w700,
);

final TextStyle cardTitleStyle = _normalTextStyle.copyWith(
  fontSize: 16,
  height: 20 / 16,
  fontWeight: FontWeight.w500,
);
final TextStyle cardDetailsStyle = _normalTextStyle.copyWith(
  color: secondFontColor,
);
final TextStyle cardTypeStyle = _boldTextStyle.copyWith(
  color: cardTypeColor,
);

final TextStyle detailsTitleStyle = _boldTextStyle.copyWith(
  fontSize: 24,
  height: 28.8 / 24,
);
final TextStyle detailsTypeStyle = _boldTextStyle;
final TextStyle detailsHoursStyle = _normalTextStyle.copyWith(
  color: secondFontColor,
);
const TextStyle detailsDetailsStyle = _normalTextStyle;

const TextStyle buttonTextStyle = _normalTextStyle;
