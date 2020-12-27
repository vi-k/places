import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../domain/sight.dart';
import '../../mocks.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import 'my_theme.dart';
import 'sight_card.dart';

/// Виджет: Список карточек.
class CardList extends StatefulWidget {
  const CardList({
    Key? key,
    required this.list,
    required this.cardType,
  }) : super(key: key);

  final Iterable<Sight> Function(BuildContext context) list;
  final SightCardType cardType;

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final iterable = widget.list(context);

    return ListView.separated(
      padding: commonPadding,
      itemCount: iterable.length,
      itemBuilder: (context, index) {
        final sight = iterable.elementAt(index);
        return widget.cardType == SightCardType.list
            ? _buildCard(sight)
            : Dismissible(
                key: ValueKey(sight.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  context.read<Mocks>().replace(
                      sight.id, sight.copyWith(state: SightState.none));
                },
                background: _buildBackground(theme),
                child: _buildCard(sight),
              );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: commonSpacing,
      ),
    );
  }

  Widget _buildCard(Sight sight) => SightCard(
        type: widget.cardType,
        sightId: sight.id,
      );

  Widget _buildBackground(MyThemeData theme) {
    final textStyle = theme.textMiddle12White;
    final textColor = textStyle.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: commonSpacing),
      child: Container(
        decoration: BoxDecoration(
          color: theme.attentionColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(commonSpacing),
          ),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: commonPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Svg24.bucket,
                  color: textColor,
                ),
                const SizedBox(height: commonSpacing1_2),
                Text(
                  stringDelete,
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
