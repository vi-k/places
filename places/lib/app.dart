import 'package:flutter/material.dart';

import 'ui/res/themes.dart';
import 'ui/screen/sight_list_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Places',
        // theme: lightTheme,
        theme: darkTheme,
        home: SightListScreen(),
      );
}
