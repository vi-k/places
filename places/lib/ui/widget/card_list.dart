import 'package:flutter/material.dart';

import '../../domain/sight.dart';
import '../res/themes.dart';
import 'sight_card.dart';

class CardList extends StatelessWidget {
  const CardList({
    Key? key,
    required this.iterable,
    required this.cardType,
  }) : super(key: key);

  final Iterable<Sight> iterable;
  final SightCardType cardType;

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: MyThemeData.listPadding,
        itemCount: iterable.length,
        itemBuilder: (context, index) => SightCard(
          type: cardType,
          sight: iterable.elementAt(index),
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
      );
}
