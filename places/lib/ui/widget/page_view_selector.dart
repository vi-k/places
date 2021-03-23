import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/app_bloc.dart';

import 'package:places/ui/res/const.dart';

/// Селектор для PageView в виде линии и точек, плавно перетекающих друг
/// в друга при изменении страницы.
class PageViewSelector extends StatefulWidget {
  const PageViewSelector({
    Key? key,
    required this.count,
    required this.controller,
  }) : super(key: key);

  /// Кол-во страниц (в контроллере не нашёл количества).
  final int count;

  /// Контроллер от PageView для управления страницами.
  final PageController controller;

  @override
  _PageViewSelectorState createState() => _PageViewSelectorState();
}

class _PageViewSelectorState extends State<PageViewSelector> {
  late PageController _controller;
  var _currentPage = 0.0;

  void _onPageChanged() => setState(() {
        _currentPage = _controller.page ?? 0;
      });

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _controller.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onPageChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppBloc>().theme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.count; i++) ...[
          const SizedBox(width: commonSpacing1_2),
          InkWell(
            onTap: () => _controller.animateToPage(
              i,
              duration: standartAnimationDuration,
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
