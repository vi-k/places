import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:places/ui/res/const.dart';

Widget standartFlightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext) {
  final fromHero = fromHeroContext.widget as Hero;
  final toHero = toHeroContext.widget as Hero;

  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) => Stack(
      children: [
        if (flightDirection == HeroFlightDirection.push) ...[
          Opacity(
            opacity: 1 - animation.value,
            child: fromHero,
          ),
          Opacity(
            opacity: animation.value,
            child: toHero,
          ),
        ] else ...[
          Opacity(
            opacity: 1 - animation.value,
            child: toHero,
          ),
          Opacity(
            opacity: animation.value,
            child: fromHero,
          ),
        ]
      ],
    ),
  );
}

Future<T?> standartNavigatorPush<T>(
        BuildContext context, Widget Function() builder) async =>
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
