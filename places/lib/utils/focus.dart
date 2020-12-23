/// Расширение для перехода фокуса по полям ввода текста.
///
import 'package:flutter/material.dart';

extension FocusScopeNodeExt on FocusScopeNode {
void nextEditableTextFocus() {
    do {
      nextFocus();
    } while (focusedChild?.context?.widget is! EditableText);
  }
}