import 'package:flutter/material.dart';

const _text = TextStyle(fontSize: 14, height: 18 / 14);

final textRegular = _text.copyWith(fontWeight: FontWeight.normal);
final textMiddle = textRegular.copyWith(fontWeight: FontWeight.w500);
final textBold = textRegular.copyWith(fontWeight: FontWeight.bold);

// final textBoldWhite = textBold.copyWith(color: Colors.white);

// final textRegular16 = textRegular.copyWith(fontSize: 16, height: 1.25);
// final textMiddle16 = textMiddle.copyWith(fontSize: 16, height: 1.25);
// final textBold16 = textBold.copyWith(fontSize: 16, height: 1.25);

// final textBold18 = textBold.copyWith(fontSize: 18, height: 1.25);

// final textRegular24 = textRegular.copyWith(fontSize: 24, height: 1.2);
// final textMiddle24 = textMiddle.copyWith(fontSize: 24, height: 1.2);
// final textBold24 = textBold.copyWith(fontSize: 24, height: 1.2);

// final textBold32 = textBold.copyWith(fontSize: 32, height: 1.125);
