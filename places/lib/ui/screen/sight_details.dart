import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../res/colors.dart';
import '../res/const.dart';
import '../res/edge_insets.dart';
import '../res/strings.dart';
import '../res/text_styles.dart';
import '../widget/loadable_image.dart';

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
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: imageBackground,
                height: detailsImageSize,
                child: LoadableImage(url: widget.sight.url),
              ),
              Padding(
                padding: detailsPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.sight.name,
                      style: textBold24,
                    ),
                    const SizedBox(
                      height: detailsTitleSpacing,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.sight.typeAsText,
                          style: textBold,
                        ),
                        const SizedBox(
                          width: detailsHoursSpacing,
                        ),
                        Text(
                          'закрыто до 09:00', // Временно
                          style: textRegularSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: detailsCommonSpacing,
                    ),
                    Text(
                      widget.sight.details,
                      style: textRegular,
                    ),
                    const SizedBox(
                      height: detailsCommonSpacing,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(0, buttonHeight),
                        ),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(buttonRadius),
                            ),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green,
                        ),
                      ),
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        assetRoute,
                        color: textColorButton,
                      ),
                      label: Text(sightDetailsScreenRoute,
                          style: textRegularButton),
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
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            assetCalendar,
                            color: textColorInactive,
                          ),
                          label: Text(
                            sightDetailsScreenSchedule,
                            style: textRegularInactive,
                          ),
                        ),
                        FlatButton.icon(
                          textColor: textColorPrimary,
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            assetFavorite,
                            color: textColorPrimary,
                          ),
                          label: Text(
                            sightDetailsScreenFavorite,
                            style: textRegular,
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
