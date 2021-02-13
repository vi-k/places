import 'package:flutter/material.dart';
import 'package:places/data/repository/base/filter.dart';
import 'package:places/ui/widget/standart_button.dart';

import '../res/const.dart';
import '../res/strings.dart';
import '../res/themes.dart';
import '../widget/search_bar.dart';
import '../widget/section.dart';
import '../widget/small_app_bar.dart';

/// Экран поиска.
///
/// TODO: реализовать поиск.
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
    required this.filter,
  }) : super(key: key);

  final Filter filter;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Filter filter;

  @override
  void initState() {
    super.initState();
    filter = widget.filter.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return Scaffold(
      appBar: SmallAppBar(
        title: stringPlaceList,
        bottom: Padding(
          padding: commonPadding,
          child: SearchBar(
            filter: filter,
            onChanged: (newFilter) {
              setState(() {
                filter = newFilter;
              });
            },
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Section(
            stringLookingFor,
            child: const SizedBox(),
          ),
          Expanded(
            child: ListView(
              children: const [],
            ),
          ),
          StandartButton(
            label: stringOk,
            onPressed: () => Navigator.pop(context, filter),
          ),
        ],
      ),
    );
  }
}
