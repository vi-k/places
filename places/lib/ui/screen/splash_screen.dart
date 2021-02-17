import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/svg.dart';

/// Сплэш-скрин.
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Splash Screen'),
              // "Прогрев" - загружаем первую картинку туториала, иначе она
              // появится позже.
              SizedBox(
                height: 0,
                child: SvgPicture.asset(SvgTutorial.tutorial1),
              ),
            ],
          ),
        ),
      );
}
