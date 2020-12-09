import 'package:flutter/material.dart';

// Texts
const String sightListScreenTitle = 'Список\nинтересных мест';
const String sightDetailsScreenRoute = 'ПОСТРОИТЬ МАРШРУТ';
const String sightDetailsScreenSchedule = 'Запланировать';
const String sightDetailsScreenFavorite = 'В Избранное';


// Screen
const Color screenBackground = Colors.white;
const Color mainFontColor = Color(0xFF3B3E5B);
const Color secondFontColor = Color(0xFF7C7E92);
final Color inactiveFontColor = secondFontColor.withOpacity(0.56);
const double buttonRadius = 12;

// AppBar
const Color appbarBackground = Colors.transparent;
const double appbarTopSpacing = 40;
const double appbarSpacing = 16;
const double appbarLineMultiplier = 1.125;
const double appbarFontSize = 32;
double get appbarLineHeight => appbarFontSize * appbarLineMultiplier;
const FontWeight appbarFontWeight = FontWeight.bold;
const TextStyle appbarTextStyle = TextStyle(
  color: mainFontColor,
  fontSize: appbarFontSize,
  height: appbarLineMultiplier,
  fontWeight: appbarFontWeight,
);

// Card
const Color cardBackground = Color(0xFFF5F5F5);
const double cardRadius = 16;
const EdgeInsetsGeometry cardPadding = EdgeInsets.all(16);
const double cardHeight = 188;
const double cardImageHeight = 96;
const double cardSpacing = 16;
const EdgeInsetsGeometry cardMargin =
    EdgeInsets.only(left: 16, right: 16, bottom: 16);
const Color cardTypeColor = Colors.white;
const TextStyle cardTitleStyle = TextStyle(
  fontSize: 16,
  color: mainFontColor,
  height: 20 / 16,
  fontWeight: FontWeight.w500,
);
const TextStyle cardDetailsStyle = TextStyle(
  fontSize: 14,
  color: secondFontColor,
  height: 18 / 14,
  fontWeight: FontWeight.normal,
);
const TextStyle cardTypeStyle = TextStyle(
  fontSize: 14,
  color: cardTypeColor,
  height: 18 / 14,
  fontWeight: FontWeight.bold,
  //shadows: [Shadow(color: Colors.white, offset: Offset(0, 0), blurRadius: 1)],
);

// Details
const Color detailsImageBackgroundColor = Colors.orange;
const double detailsImageSize = 360;
const EdgeInsets detailsPadding =
    EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 16);
const double detailsTitleSpacing = 2;
const double detailsHoursSpacing = 16;
const double detailsCommonSpacing = 24;
const double detailsFooterSpacing = 8;
const TextStyle detailsTitleStyle = TextStyle(
  fontSize: 24,
  color: mainFontColor,
  height: 28.8 / 24,
  fontWeight: FontWeight.bold,
);
const TextStyle detailsTypeStyle = TextStyle(
  fontSize: 14,
  color: mainFontColor,
  height: 18 / 14,
  fontWeight: FontWeight.bold,
);
const TextStyle detailsHoursStyle = TextStyle(
  fontSize: 14,
  color: secondFontColor,
  height: 18 / 14,
  fontWeight: FontWeight.normal,
);
const TextStyle detailsDetailsStyle = TextStyle(
  fontSize: 14,
  color: mainFontColor,
  height: 18 / 14,
  fontWeight: FontWeight.normal,
);
const TextStyle buttonTextStyle = TextStyle(
  fontSize: 14,
  height: 18 / 14,
  fontWeight: FontWeight.normal,
);
