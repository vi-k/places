import 'package:flutter/material.dart';

// Screen
const Color screenBackground = Colors.white;

// AppBar
const Color appbarBackground = Colors.transparent;
const double appbarTopSpacing = 40;
const double appbarSpacing = 16;
const double appbarLineMultiplier = 1.125;
const double appbarFontSize = 32;
double get appbarLineHeight => appbarFontSize * appbarLineMultiplier;
const Color appbarFontColor = Color(0xFF3B3E5B);
const FontWeight appbarFontWeight = FontWeight.w700;
const Color appbarFirstLineInitialLetterColor = Colors.green;
const Color appbarSecondLineInitialLetterColor = Colors.yellow;

// Screens
const String sightListScreenTitle = 'Список\nинтересных мест';
// const String sightListScreenTitle = 'Список интересных мест';
// const String sightListScreenTitle = 'Список\nинтересных\nмест';

// Card
const Color cardBackground = Color(0xFFF5F5F5);
const EdgeInsetsGeometry cardPadding = EdgeInsets.all(16);
const double cardHeight = 200;
const EdgeInsetsGeometry cardMargin =
    EdgeInsets.only(left: 16, right: 16, bottom: 16);
