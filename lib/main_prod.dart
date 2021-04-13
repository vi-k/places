import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'environment/build_config.dart';
import 'environment/build_type.dart';
import 'environment/environment.dart';

void main() {
  Environment.init(
    buildType: BuildType.prod,
    buildConfig: const BuildConfig(message: "It's a prod flavor"),
  );

  Intl.defaultLocale = 'ru_RU';

  runApp(App());
}
