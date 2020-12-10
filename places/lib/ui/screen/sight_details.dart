import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/sight.dart';
import '../res/colors.dart';
import '../res/const.dart';
import '../res/edge_insets.dart';
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
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: imageBackground, // Временно
                height: detailsImageSize,
                child: Image.network(
                  widget.sight.url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(
                        backgroundColor: imageBackground,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
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
                          style:
                              textRegular.copyWith(color: textColorSecondary),
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
                        minimumSize: MaterialStateProperty.all(Size(0, 48)),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(buttonRadius),
                            ),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'res/route.svg',
                        color: textColorButton,
                      ),
                      label: Text(sightDetailsScreenRoute,
                          style: textFlatRegular.copyWith(
                            color: textColorButton,
                          )),
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
                            'res/calendar.svg',
                            color: textColorInactive,
                          ),
                          label: Text(
                            sightDetailsScreenSchedule,
                            style: textRegular.copyWith(
                              color: textColorInactive,
                            ),
                          ),
                        ),
                        FlatButton.icon(
                          textColor: textColorPrimary,
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'res/favorite.svg',
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
