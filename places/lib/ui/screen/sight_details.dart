import 'package:flutter/material.dart';

import '../../domain/sight.dart';
import '../res/colors.dart';
import '../res/const.dart';
import '../res/strings.dart';
import '../res/text_styles.dart';

class SightDetails extends StatefulWidget {
  final Sight sight;

  const SightDetails({
    Key? key,
    required this.sight,
  }) : super(key: key);

  @override
  _SightDetailsState createState() => _SightDetailsState();
}

class _SightDetailsState extends State<SightDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: detailsImageBackgroundColor, // Временно
              height: detailsImageSize,
              child: Image.network(
                widget.sight.url,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: detailsPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.sight.name,
                    style: detailsTitleStyle,
                  ),
                  const SizedBox(
                    height: detailsTitleSpacing,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.sight.typeAsText,
                        style: detailsTypeStyle,
                      ),
                      const SizedBox(
                        width: detailsHoursSpacing,
                      ),
                      Text(
                        'закрыто до 09:00', // Временно
                        style: detailsHoursStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: detailsCommonSpacing,
                  ),
                  Text(
                    widget.sight.details,
                    style: detailsDetailsStyle,
                  ),
                  const SizedBox(
                    height: detailsCommonSpacing,
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(buttonRadius),
                          ),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.rowing),
                    label: const Text(sightDetailsScreenRoute),
                  ),
                  const SizedBox(
                    height: detailsCommonSpacing,
                  ),
                  const Divider(
                    height: 0,
                  ),
                  const SizedBox(
                    height: detailsFooterSpacing,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton.icon(
                        textColor: inactiveFontColor,
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_today),
                        label: const Text(
                          sightDetailsScreenSchedule,
                          style: buttonTextStyle,
                        ),
                      ),
                      FlatButton.icon(
                        textColor: mainFontColor,
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                        label: const Text(
                          sightDetailsScreenFavorite,
                          style: buttonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
