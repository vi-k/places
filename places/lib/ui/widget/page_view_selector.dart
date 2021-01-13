import 'package:flutter/material.dart';

import '../res/const.dart';
import '../res/themes.dart';

class PageViewSelector extends StatefulWidget {
  const PageViewSelector({
    Key? key,
    required this.count,
    required this.controller,
  }) : super(key: key);

  final int count;
  final PageController controller;

  @override
  _PageViewSelectorState createState() => _PageViewSelectorState();
}

class _PageViewSelectorState extends State<PageViewSelector> {
  late PageController _controller;
  var _currentPage = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.count; i++) ...[
          const SizedBox(width: commonSpacing1_2),
          InkWell(
            onTap: () => _controller.animateToPage(
              i,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            ),
            child: Container(
              height: commonSpacing1_2,
              width: commonSpacing1_2 +
                  (1 - (_currentPage - i).abs().clamp(0, 1)) * 16,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  theme.lightTextColor
                      .withOpacity((_currentPage - i).abs().clamp(0, 1)),
                  theme.accentColor,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(commonSpacing1_2),
              ),
            ),
          ),
        ],
        const SizedBox(width: commonSpacing1_2),
      ],
    );
  }
}
