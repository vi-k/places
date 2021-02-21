import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';

import 'standart_button.dart';

/// Вызывает виджет выбора даты для iOS по аналогии с showDatePicker
/// для Material.
Future<DateTime?> showCupertinoDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
}) =>
    showModalBottomSheet<DateTime>(
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(commonSpacing3_4),
        ),
      ),
      builder: (context) => CupertinoDateSelect(
        initialDate: initialDate,
        firstDate: firstDate,
      ),
    );

/// Выбора даты для iOS.
class CupertinoDateSelect extends StatefulWidget {
  const CupertinoDateSelect({
    Key? key,
    required this.initialDate,
    required this.firstDate,
  }) : super(key: key);

  final DateTime initialDate;
  final DateTime firstDate;

  @override
  CupertinoDateSelectState createState() => CupertinoDateSelectState();
}

class CupertinoDateSelectState extends State<CupertinoDateSelect> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CupertinoDatePicker(
              initialDateTime: widget.initialDate,
              minimumDate: widget.firstDate,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (date) => this.date = date,
            ),
          ),
          Padding(
            padding: commonPaddingLBR,
            child: StandartButton(
              label: stringOk,
              onPressed: () => Navigator.pop(context, date),
            ),
          ),
        ],
      );
}
