import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

/// Сплэш-скрин.
///
/// Ждёт завершения инициализации. Показывается минимум 2 сек.
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Флаг инициализации приложения. Ставим временную заглушку в 1 сек.
  final isInitialized =
      Future<bool>.delayed(const Duration(seconds: 1), () => true);

  @override
  void initState() {
    super.initState();

    _navigateToNext();
  }

  // ignore: avoid_void_async
  void _navigateToNext() async {
    final sw = Stopwatch();

    // Ждём завершения инициализации приложения. Но держим SplashScreen минимум
    // 2 сек.
    print('Инициализация приложения');
    sw.start();
    await Future.wait([
      isInitialized,
      Future<bool>.delayed(const Duration(seconds: 2), () => true),
    ]);
    sw.stop();
    print('Затрачено: ${sw.elapsed}');
    print('Переход на следующий экран');

    // Переходим к OnboardingScreen, пока не реализовали сохранение настроек.
    await Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute(
        builder: (_) => OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text('Splash Screen'),
        ),
      );
}
