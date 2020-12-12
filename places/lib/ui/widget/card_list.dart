import 'package:flutter/material.dart';

import '../../domain/sight.dart';
import '../res/edge_insets.dart';
import 'sight_card.dart';

class CardList extends StatelessWidget {
  const CardList({
    Key? key,
    required this.iterable,
  }) : super(key: key);

  final Iterable<Sight> iterable;

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: listPadding,
        itemCount: iterable.length,
        itemBuilder: (context, index) => SightCard(
          sight: iterable.elementAt(index),
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
      );
}
