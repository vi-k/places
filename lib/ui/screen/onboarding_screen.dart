import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/app/app_bloc.dart';
import 'package:places/ui/res/const.dart';
import 'package:places/ui/res/strings.dart';
import 'package:places/ui/res/svg.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/widget/page_view_selector.dart';
import 'package:places/ui/widget/small_button.dart';
import 'package:places/ui/widget/standart_button.dart';
import 'package:provider/provider.dart';

/// Экран туториала.
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  static const int _pageCount = 3;
  static const double _lastPage = _pageCount - 1;

  late final List<AnimationController> _animControllers =
      List<AnimationController>.generate(
    _pageCount,
    (index) => AnimationController(
      vsync: this,
      duration: standartAnimationDuration * 2,
    ),
  );

  late final List<Animation<double>> _animations =
      List<Animation<double>>.generate(
    _pageCount,
    (index) => Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        curve: Curves.elasticOut,
        parent: _animControllers[index],
      ),
    ),
  );

  late final PageController _pageController = PageController()
    ..addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
        final pageIndex = _currentPage.round();
        if ((_currentPage - pageIndex).abs() < 0.05) {
          final animController = _animControllers[pageIndex];
          if (animController.isDismissed) {
            animController.forward();
          }
        }
      });
    });

  var _currentPage = 0.0;

  late MyThemeData _theme;

  @override
  void dispose() {
    _pageController.dispose();

    for (final animController in _animControllers) {
      animController.dispose();
    }

    super.dispose();
  }

  void _skip() {
    if (Navigator.canPop(context)) {
      // Если вызвали из настроек, то возвращаемся
      Navigator.pop(context);
    } else {
      // Если это первый экран, то запускаем основной экран
      context
          .read<AppBloc>()
          .add(const AppSettingsChanged(showTutorial: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.watch<AppBloc>().theme;

    final translate = _currentPage >= _lastPage - 0.5
        ? 1 - (_lastPage - _currentPage) * 2
        : 0.0;

    // Запуск первой анимации надо задержать.
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _animControllers[0].forward();
    });

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._buildTop(translate),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildTutorial(
                  pageIndex: 0,
                  svg: SvgTutorial.tutorial1,
                  caption: tutorial1Caption,
                  description: tutorial1Description,
                ),
                _buildTutorial(
                  pageIndex: 1,
                  svg: SvgTutorial.tutorial2,
                  caption: tutorial2Caption,
                  description: tutorial2Description,
                ),
                _buildTutorial(
                  pageIndex: 2,
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

  List<Widget> _buildTop(double translate) {
    final top = MediaQuery.of(context).padding.top + commonSpacing1_2;

    return [
      SizedBox(height: top),
      Transform.translate(
        offset: Offset(0, -translate * (top + smallButtonHeight)),
        child: Align(
          alignment: Alignment.topRight,
          child: SmallButton(
            style: _theme.textMiddle16Accent,
            label: stringSkip,
            onPressed: _skip,
          ),
        ),
      ),
    ];
  }

  Widget _buildTutorial({
    required int pageIndex,
    required String svg,
    required String caption,
    required String description,
  }) {
    final image = SvgPicture.asset(svg, color: _theme.mainTextColor2);

    return Padding(
      padding: commonPaddingLR * 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimatedBuilder(
            animation: _animControllers[pageIndex],
            builder: (context, child) => Transform.scale(
              scale: _animations[pageIndex].value,
              child: child,
            ),
            child: image,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                caption,
                textAlign: TextAlign.center,
                style: _theme.textBold24Main2,
              ),
              const SizedBox(height: commonSpacing),
              Text(
                description,
                textAlign: TextAlign.center,
                style: _theme.textRegular14Light,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageSelector() => Center(
        child: Padding(
          padding: commonPaddingLTR,
          child: PageViewSelector(
            count: 3,
            controller: _pageController,
          ),
        ),
      );

  Widget _buildBottom(double translate) => Container(
        padding: commonPadding,
        child: Transform.translate(
          offset: Offset(
            0,
            (1 - translate) * (standartButtonHeight + commonSpacing),
          ),
          child: StandartButton(
            label: stringStart,
            onPressed: _skip,
          ),
        ),
      );
}
