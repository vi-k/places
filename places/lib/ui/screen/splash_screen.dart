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
  late final AnimationController _animController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animController.repeat();

    _animation = Tween<double>(begin: 0, end: -2 * pi).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animController,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFCDD3D),
                Color(0xFF4CAF50),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) => Transform.rotate(
                    angle: _animation.value,
                    child: child,
                  ),
                  child: SvgPicture.asset(SvgSplash.splash),
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
        ),
      );
}
