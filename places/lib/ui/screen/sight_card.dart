import 'package:flutter/material.dart';

import '../../domain/sight.dart';
import '../res/colors.dart';
import '../res/const.dart';
import '../res/edge_insets.dart';
import '../res/text_styles.dart';
import 'sight_details.dart';

class SightCard extends StatelessWidget {
  final Sight sight;

  const SightCard({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 3 / 2,
        child: Card(
          margin: cardMargin,
          color: cardBackground,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cardRadius),
              topRight: Radius.circular(cardRadius),
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTop(),
                  _buildBottom(),
                ],
              ),
              Positioned.fill(
                child: MaterialButton(
                  highlightColor: Colors.black12,
                  splashColor: Colors.black12,
                  onPressed: () {
                    Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SightDetails(sight: sight),
                        ));
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //   content: Text('Test!'),
                    //   duration: Duration(milliseconds: 300),
                    // ));
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTop() => Expanded(
        child: Container(
          color: Colors.orange,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                sight.url,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: cardSpacing,
                top: cardSpacing,
                child: Text(
                  sight.typeAsText,
                  style: cardTypeStyle,
                ),
              ),
              const Positioned(
                right: cardSpacing,
                top: cardSpacing,
                child: Icon(
                  Icons.favorite_outline,
                  color: Colors.white, // Временно
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildBottom() => Expanded(
        child: Container(
          padding: cardPadding,
          child: UnconstrainedBox(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                text: TextSpan(
                  text: '${sight.name}\n',
                  style: cardTitleStyle,
                  children: [
                    TextSpan(
                      text: sight.details,
                      style: cardDetailsStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
