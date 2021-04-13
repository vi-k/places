import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/svg.dart';

/// Сплэш-скрин.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  late final Animation<double> _animation =
      Tween<double>(begin: 0, end: 4 * pi).animate(CurvedAnimation(
    curve: Curves.easeInOutCirc,
    parent: _animController,
  ));

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'res/splash_background.png',
                fit: BoxFit.fill,
                colorBlendMode: BlendMode.multiply,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) => Transform.rotate(
                      angle: _animation.value,
                      child: child,
                    ),
                    child: SvgPicture.asset(SvgAny.splash),
                  ),
                  // "Прогрев" - загружаем первую картинку туториала, иначе она
                  // появится позже.
                  SizedBox(
                    height: 0,
                    child: SvgPicture.asset(SvgTutorial.tutorial1),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
