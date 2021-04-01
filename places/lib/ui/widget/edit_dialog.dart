import 'package:flutter/material.dart';
import 'package:places/ui/res/strings.dart';

import 'small_button.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({
    Key? key,
    this.title,
    this.initialText = '',
    required this.builder,
    this.actions,
  }) : super(key: key);

  final Widget? title;
  final String initialText;
  final Widget Function(BuildContext context, TextEditingController controller)
      builder;
  final List<Widget>? actions;

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late final TextEditingController _textController =
      TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: widget.title,
        content: widget.builder(context, _textController),
        actions: [
          SmallButton(
            label: stringCancel,
            onPressed: () => Navigator.pop(context),
          ),
          SmallButton(
            label: stringOk,
            onPressed: () => Navigator.pop(context, _textController.value.text),
          ),
        ],
      );
}
