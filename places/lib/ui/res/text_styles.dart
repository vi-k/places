import 'package:flutter/material.dart';

import 'colors.dart';
import 'const.dart';

const _normalTextStyle = TextStyle(
  fontSize: 14,
  height: 18 / 14,
  color: mainFontColor,
  fontWeight: FontWeight.normal,
);

final _boldTextStyle = _normalTextStyle.copyWith(
  fontWeight: FontWeight.bold,
);

const buttonTextStyle = _normalTextStyle;

final appbarTextStyle = _boldTextStyle.copyWith(
  fontSize: 32,
  height: appbarLineMultiplier,
  fontWeight: FontWeight.w700,
);

final cardTitleStyle = _normalTextStyle.copyWith(
  fontSize: 16,
  height: 20 / 16,
  fontWeight: FontWeight.w500,
);
final cardDetailsStyle = _normalTextStyle.copyWith(
  color: secondFontColor,
);
final cardTypeStyle = _boldTextStyle.copyWith(
  color: cardTypeColor,
);

final detailsTitleStyle = _boldTextStyle.copyWith(
  fontSize: 24,
  height: 28.8 / 24,
);
final detailsTypeStyle = _boldTextStyle;
final detailsHoursStyle = _normalTextStyle.copyWith(
  color: secondFontColor,
);
const detailsDetailsStyle = _normalTextStyle;
