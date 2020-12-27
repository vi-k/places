import 'package:flutter/material.dart';

/// Расширение для перехода фокуса по полям ввода текста.
extension FocusScopeNodeExt on FocusScopeNode {
  void nextEditableTextFocus() {
    do {
      nextFocus();
    } while (focusedChild?.context?.widget is! EditableText);
  }
}
