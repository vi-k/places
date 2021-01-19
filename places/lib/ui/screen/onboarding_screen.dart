import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import '../widget/page_view_selector.dart';
import '../widget/small_button.dart';
import '../widget/standart_button.dart';
import 'sight_list_screen.dart';

/// Экран туториала.
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _lastPage = 2.0;

  final _controller = PageController();
  var _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
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

  void _skip() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute(
          builder: (context) => SightListScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context, listen: true);
    final translate = _currentPage >= _lastPage - 0.5
        ? 1 - (_lastPage - _currentPage) * 2
        : 0.0;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._buildTop(theme, translate),
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                _buildTutorial(
                  theme,
                  svg: SvgTutorial.tutorial1,
                  caption: tutorial1Caption,
                  description: tutorial1Description,
                ),
                _buildTutorial(
                  theme,
                  svg: SvgTutorial.tutorial2,
                  caption: tutorial2Caption,
                  description: tutorial2Description,
                ),
                _buildTutorial(
                  theme,
                  svg: SvgTutorial.tutorial3,
                  caption: tutorial3Caption,
                  description: tutorial3Description,
                ),
              ],
            ),
          ),
          _buildPageSelector(),
          _buildBottom(translate),
        ],
      ),
    );
  }

  List<Widget> _buildTop(MyThemeData theme, double translate) {
    final top = MediaQuery.of(context).padding.top + commonSpacing1_2;

    return [
      SizedBox(height: top),
      Transform.translate(
        offset: Offset(0, -translate * (top + smallButtonHeight)),
        child: Align(
          alignment: Alignment.topRight,
          child: SmallButton(
            style: theme.textMiddle16Accent,
            label: stringSkip,
            onPressed: _skip,
          ),
        ),
      ),
    ];
  }

  Widget _buildTutorial(
    MyThemeData theme, {
    required String svg,
    required String caption,
    required String description,
  }) =>
      Center(
        child: Padding(
          padding: commonPadding * 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(svg, color: theme.mainTextColor2),
              const SizedBox(
                height: 3 * commonSpacing,
              ),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: theme.textBold24Main2,
              ),
              const SizedBox(
                height: commonSpacing1_2,
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textRegular14Light,
              ),
            ],
          ),
        ),
      );

  Widget _buildPageSelector() => Center(
        child: Padding(
          padding: commonPadding,
          child: PageViewSelector(
            count: 3,
            controller: _controller,
          ),
        ),
      );

  Widget _buildBottom(double translate) => Container(
        padding: commonPadding,
        child: Transform.translate(
          offset: Offset(
              0, (1 - translate) * (standartButtonHeight + commonSpacing)),
          child: StandartButton(
            label: stringStart,
            onPressed: _skip,
          ),
        ),
      );
}
