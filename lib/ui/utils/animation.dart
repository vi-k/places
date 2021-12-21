import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:places/ui/res/const.dart';

// ignore: long-parameter-list
Widget standartFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final Widget bottomHero;
  final Widget topHero;

  if (flightDirection == HeroFlightDirection.push) {
    bottomHero = fromHeroContext.widget as Hero;
    topHero = toHeroContext.widget as Hero;
  } else {
    bottomHero = toHeroContext.widget as Hero;
    topHero = fromHeroContext.widget as Hero;
  }

  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) => Stack(
      children: [
        Opacity(
          opacity: 1 - animation.value,
          child: bottomHero,
        ),
        Opacity(
          opacity: animation.value,
          child: topHero,
        ),
      ],
    ),
  );
}

Future<T?> standartNavigatorPush<T>(
  BuildContext context,
  Widget Function() builder,
) async =>
    Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => builder(),
        transitionDuration: standartAnimationDuration,
        reverseTransitionDuration: standartAnimationDuration,
        transitionsBuilder: (context, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              reverseCurve: Curves.fastOutSlowIn.flipped,
              parent: animation,
            ),
          ),
          child: child,
        ),
      ),
    );
