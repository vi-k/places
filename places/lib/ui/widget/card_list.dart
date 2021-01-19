import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/svg.dart';
import '../res/themes.dart';
import 'mocks.dart';
import 'sight_card.dart';

/// Список карточек.
class CardList extends StatefulWidget {
  const CardList({
    Key? key,
    required this.list,
    required this.cardType,
  }) : super(key: key);

  /// Список мест.
  final Iterable<Sight> Function(BuildContext context) list;

  /// Тип карточки: list, favorites, visited.
  final SightCardType cardType;

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  bool _draggableMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final iterable = widget.list(context);

    return _draggableMode
        ? _buildDraggableList(iterable, theme)
        : _buildNormalList(iterable, theme);
  }

  // Обычный список.
  Widget _buildNormalList(Iterable<Sight> iterable, MyThemeData theme) =>
      ListView.separated(
        padding: commonPadding,
        itemCount: iterable.length,
        itemBuilder: (context, index) {
          final sight = iterable.elementAt(index);
          return widget.cardType == SightCardType.list
              ? _buildCard(sight)
              : Dismissible(
                  key: ValueKey(sight.id),
                  direction: widget.cardType == SightCardType.favorites
                      ? DismissDirection.horizontal
                      : DismissDirection.endToStart,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      if (widget.cardType == SightCardType.favorites) {
                        Mocks.of(context).removeFromFavorite(sight.id);
                      } else if (widget.cardType == SightCardType.visited) {
                        Mocks.of(context).removeFromVisited(sight.id);
                      }
                    } else if (direction == DismissDirection.startToEnd) {
                      Mocks.of(context).removeFromFavorite(sight.id);
                      Mocks.of(context).addToVisited(sight.id);
                    }
                  },
                  background: _buildBackground(theme,
                      color: theme.accentColor,
                      svg: Svg24.tick,
                      label: stringToVisited,
                      alignment: Alignment.centerLeft),
                  secondaryBackground: _buildBackground(theme,
                      color: theme.attentionColor,
                      svg: Svg24.bucket,
                      label: stringDelete,
                      alignment: Alignment.centerRight),
                  child: _buildCard(sight),
                );
        },
        separatorBuilder: (context, index) =>
            const SizedBox(height: commonSpacing),
      );

  // Список в режиме перемещения.
  Widget _buildDraggableList(Iterable<Sight> iterable, MyThemeData theme) =>
      ListView.builder(
        padding: commonPadding,
        itemCount: iterable.length * 2 + 1,
        itemBuilder: (context, index) {
          if (index.isEven) {
            final targetIndex = index ~/ 2;
            return DragTarget<int>(
              onWillAccept: (value) =>
                  value != null &&
                  targetIndex != value &&
                  targetIndex != value + 1,
              onAccept: (value) {
                Mocks.of(context).moveFavorite(value, targetIndex);
              },
              builder: (context, candidateData, _) => candidateData.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: commonSpacing),
                        _buildCardBack(theme, Colors.orange),
                        const SizedBox(height: commonSpacing),
                      ],
                    )
                  : const SizedBox(
                      height: commonSpacing,
                    ),
            );
          }

          final sightIndex = index ~/ 2;
          final sight = iterable.elementAt(sightIndex);
          return Draggable<int>(
            data: sightIndex,
            feedback: _buildCard(sight),
            childWhenDragging: _buildCardBack(theme),
            child: _buildCard(sight),
          );
        },
      );

  Widget _buildCard(Sight sight) => SightCard(
        type: widget.cardType,
        sightId: sight.id,
        onLongPress: widget.cardType != SightCardType.favorites
            ? null
            : () => setState(() => _draggableMode = !_draggableMode),
      );

  Widget _buildCardBack(MyThemeData theme, [Color? color]) => AspectRatio(
        aspectRatio: cardAspectRatio,
        child: Card(
          elevation: 0,
          color: color ?? theme.backgroundSecond,
        ),
      );

  Widget _buildBackground(
    MyThemeData theme, {
    required Color color,
    required String svg,
    required String label,
    required Alignment alignment,
  }) {
    final textStyle = theme.textMiddle12White;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: commonSpacing),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(commonSpacing),
          ),
        ),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: commonPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  svg,
                  color: textStyle.color,
                ),
                const SizedBox(height: commonSpacing1_2),
                Text(
                  label,
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
